Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:47071 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3B0NMa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:12:30 -0500
Received: by mail-ia0-f182.google.com with SMTP id k38so444950iah.27
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 05:12:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130227130344.GC27541@twin.jikos.cz>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
	<1361832890-40921-15-git-send-email-sandeen@redhat.com>
	<CAP9B-QkUP7ZftFkWw-_W-K2YKT8KdymabTf2mEK8Z_mgiKaJnA@mail.gmail.com>
	<512C3BD9.6000008@redhat.com>
	<20130227130344.GC27541@twin.jikos.cz>
Date: Wed, 27 Feb 2013 21:12:29 +0800
Message-ID: <CAP9B-QkKmPG4gMOyVM2pXyXO3vGz4GvoFKR2kYhi_gMRfobQ6g@mail.gmail.com>
Subject: Re: [PATCH 14/17] btrfs-progs: fix mem leak in resolve_root
From: Shilong Wang <wangshilong1991@gmail.com>
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        Shilong Wang <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Eric, David

2013/2/27 David Sterba <dsterba@suse.cz>:
> On Mon, Feb 25, 2013 at 10:36:41PM -0600, Eric Sandeen wrote:
>> On 2/25/13 6:36 PM, Shilong Wang wrote:
>> >> --- a/btrfs-list.c
>> >> +++ b/btrfs-list.c
>> >> @@ -568,8 +568,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>> >>                 * ref_tree = 0 indicates the subvolumes
>> >>                 * has been deleted.
>> >>                 */
>> >> -               if (!found->ref_tree)
>> >> +               if (!found->ref_tree) {
>> >> +                       free(full_path);
>> >>                         return -ENOENT;
>> >> +               }
>> >>                 int add_len = strlen(found->path);
>> >>
>> >>                 /* room for / and for null */
>> >> @@ -612,8 +614,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>> >>                 * subvolume was deleted.
>> >>                 */
>> >>                 found = root_tree_search(rl, next);
>> >> -               if (!found)
>> >> +               if (!found) {
>> >> +                       free(full_path);
>> >>                         return -ENOENT;
>> >> +               }
>> >>         }
>> >>
>> >>         ri->full_path = full_path;
>> >> --
>> >> 1.7.1
>> >
>> > I think the patch is wrong;
>> > Here we return ENOENT, it means a subvolume/snapshot deletion happens.
>> > We just filter them in the filter_root, But the free work is done by
>> > the function all_subvolume_free..
>> > so your modification will cause a double free..
>>
>> Thanks for the review.  I'll admit that when looking at too many of
>> these static checker reports, sometimes things look obvious when
>> they are actually subtle, and I've certainly made mistakes before. :)
>>
>> However, full_path location doesn't seem to be available outside the
>> scope of this function unless we exit normally and do:
>>
>>         ri->full_path = full_path;
>>
>>         return 0;
>> }
>>
>> If we exit early at the -ENOENT points, it seems that full_path
>> is leaked; there are no other references to it.

I looked the code carefully, i was wrong before..
Agree with the patch

Thanks,
Wang
>
> I agree with you, the freed value is local.
>
> david
