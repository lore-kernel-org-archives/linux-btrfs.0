Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60F6C282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 10:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A469821872
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 10:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfAXKkP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:40:15 -0500
Received: from icp-osb-irony-out6.external.iinet.net.au ([203.59.1.106]:60135
        "EHLO icp-osb-irony-out6.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbfAXKkP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 05:40:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2B5AAC2lElc/1rB77ZkGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBZYIEZk8zJ4QBiHmMcwglNQGDTJQZgWcyBgGEOgQCAoJ/Izg?=
 =?us-ascii?q?SAQMBAQEBAQECbRwMhUoBAQEBAgEjBAsBIxwHBQsLGAICFQIPAgI5DREGAQw?=
 =?us-ascii?q?GAgEBgx4BgXkHEKtVfDOELgGBFIRtBYELi02BQD+BOAxkfVAuhEoEARIBCHI?=
 =?us-ascii?q?DgiuCNSICoiwJDYIohHWHBYNwHoFpJoV0glCHS4oLhSKNZSFlcWwZO4JsE4I?=
 =?us-ascii?q?UF4hfhVMuMAGBAgGHWQ8XgicBAQ?=
X-IPAS-Result: =?us-ascii?q?A2B5AAC2lElc/1rB77ZkGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?YIEZk8zJ4QBiHmMcwglNQGDTJQZgWcyBgGEOgQCAoJ/IzgSAQMBAQEBAQECb?=
 =?us-ascii?q?RwMhUoBAQEBAgEjBAsBIxwHBQsLGAICFQIPAgI5DREGAQwGAgEBgx4BgXkHE?=
 =?us-ascii?q?KtVfDOELgGBFIRtBYELi02BQD+BOAxkfVAuhEoEARIBCHIDgiuCNSICoiwJD?=
 =?us-ascii?q?YIohHWHBYNwHoFpJoV0glCHS4oLhSKNZSFlcWwZO4JsE4IUF4hfhVMuMAGBA?=
 =?us-ascii?q?gGHWQ8XgicBAQ?=
X-IronPort-AV: E=Sophos;i="5.56,515,1539619200"; 
   d="scan'208";a="134677227"
Received: from 182-239-193-90.ip.adam.com.au (HELO Oberon.Underworld) ([182.239.193.90])
  by icp-osb-irony-out6.iinet.net.au with ESMTP; 24 Jan 2019 18:40:10 +0800
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
 <f191c52b-740f-f432-1307-dbb8f4010f66@suse.com>
 <f2d23645-ebd4-3799-bad8-2050764375bc@mendix.com>
From:   Dennis K <dennisk@netspace.net.au>
Openpgp: preference=signencrypt
Message-ID: <d44d7535-7590-662e-ddd0-e095cb5156a4@netspace.net.au>
Date:   Thu, 24 Jan 2019 21:40:51 +1100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <f2d23645-ebd4-3799-bad8-2050764375bc@mendix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 24/1/19 3:23 am, Hans van Kranenburg wrote:
> On 1/23/19 4:32 PM, Nikolay Borisov wrote:
>>
>>
>> On 23.01.19 г. 17:25 ч., Hans van Kranenburg wrote:
>>> On 1/23/19 12:25 PM, Andrei Borzenkov wrote:
>>>> On Wed, Jan 23, 2019 at 1:45 PM Dennis Katsonis <dennisk@netspace.net.au> wrote:
>>>>> I think my previous e-mail did not go through.  Basically, if it is
>>>>> assumed that a btrfs-receive operation will result in a subvolume which
>>>>> matches the source file for file, then this assumption or expectation
>>>>> won't be met if one deletes files from the subvolume at the receiving
>>>>> end which is going to be referred to as the parent. 
>>>>>
>>>>
>>>> This is oxymoron. btrfs send/receive apply to read-only subvolumes.
>>>> You are not able to modify them. As soon as you remove read-only bit,
>>>> you are fully responsible for consequences.
>>>>
>>>>> This can happen inadvertently,
>>>>
>>>> It cannot. You do not inadvertently make subvolume read-write. And if
>>>> you do, you are expected to know what you are doing.
>>>>
>>>> That said, better if btrfs did not allow flipping read-only bit in the
>>>> first place.
>>>
>>> +100
>>>
>>> But then only disallow if the subvol has a value in the received_uuid
>>> field, I'd say.
>>>
>>> And the tooling could display a nice error message, telling the user to
>>> make a rw snapshot of the received subvol instead, which will have an
>>> empty received_uuid field again.
>>>
>>> ERROR: subvolume is a received subvolume, which cannot be made read-write
>>> ERROR: suggestion; make a read-write snapshot of it instead
>>>
>>> Setting something ro manually (e.g. to prevent accidental deletion of a
>>> static set of data) is still also a use case.
>>
>> I had a patch which when the ro bit is flipped on a snapshot, then it's
>> parent snapshot uuid etc is deleted. Because at that point it cannot be
>> guaranteed that there is any relationship between paren<->snapshot. Ie:
>>
>> https://lore.kernel.org/linux-btrfs/1520847020-8049-1-git-send-email-nborisov@suse.com/
>>
>> has anyone tried it?
> 
> Oh, it seems that one never got any reply.
> 
> When looking at it from an end user perspective, I'd much more like to
> have it explicitly tell me I'm doing something stupid, refuse and
> educate me than obeying and adding more implicit behaviour that I cannot
> revert any more myself.
> 
It was the new user I had primarily in mind.  Btrfs is the default for
OpenSUSE, and may become the default for more distros.  Thats a lot of
new users, unaware of the vaguaries of COW filesystems who first learn
how to use the tools to solve their problems, before they learn the
"gotchas".

The fact is, this thread is the first time I've seen explicitly written
that parents must be the same at receiving and sending ends, or else
btrfs-send/receive will produce a subvolume which differs from the source.

A user could from the descriptions of how send/receive formats its data
strea, and from interpreting "clone sources" in a manner contrary to how
its used in the man page and the mention of incrementals, conclude that
send/receive is sensitive to changes at the receiving side, but its far,
far more likely that they will start using feature like send/receive and
setting snapshots to ro before they delve into how it works its magic.
Anyway, rsync sends incremental change, and its ability to replicate a
directory tree isn't predicated on the files present at the receiving
end being the same as the last time it was run...




> E.g. I'm a new btrfs user, I just sent this 1TiB of data for the first
> time, and now I'm of course curious and trying more things out.
> 
> Trying setting rw ('ooh! that works') and then quickly setting ro back
> will destroy the send/receive relationship without mentioning anything
> to the user, and in combination with subsequent cryptic errors from
> incremental send/receive ("cannot find parent subvolume" or something)
> it will end up with smashing keyboards and throwing computers out of the
> window.
> 
> After asking on IRC and providing output of btrfs sub list etc the user
> is told that that subvol was never received because it doesn't have a
> received_uuid, and then someone asks "did you turn it rw at some
> point?". Now the user remembers, "yes, I was experimenting and I didn't
> see an error or warning", and is then told to resend the 1TiB of data.
> "But it's there already!" Now someone comes up with a snippet of python
> code to reset the received_uuid with the ioctl, and...
> 
> :D
> 
>>>>> or even through filesystem corruption
>>>>> (which I experienced).
>>>>>
>>>>
>>>> And if corruption happened after applying changes? End result in the
>>>> same. Of course it would be perfect if btrfs could notice and warn
>>>> you, I just do not see how it can realistically be implemented.
>>>>
>>>
>>>
> 
> 
