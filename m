Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab3BLHeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 02:34:25 -0500
Message-ID: <5119F078.7030309@suse.com>
Date: Tue, 12 Feb 2013 02:34:16 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
Cc: Eric Sandeen <sandeen@redhat.com>, Zach Brown <zab@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add delayed_iput list head to btrfs inode
References: <511180E4.2020600@redhat.com> <20130205231405.GM14246@lenny.home.zabbo.net> <20130206020854.GA2278@liubo.jp.oracle.com> <51127C61.3070503@redhat.com> <20130206160255.GB30198@liubo.jp.oracle.com>
In-Reply-To: <20130206160255.GB30198@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/6/13 11:02 AM, Liu Bo wrote:
> On Wed, Feb 06, 2013 at 09:53:05AM -0600, Eric Sandeen wrote:
>> On 2/5/13 8:08 PM, Liu Bo wrote:
>>> On Tue, Feb 05, 2013 at 03:14:05PM -0800, Zach Brown wrote:
>>>>> +	struct btrfs_inode *b_inode = BTRFS_I(inode); +	struct
>>>>> btrfs_fs_info *fs_info = b_inode->root->fs_info;
>>>>> 
>>>>> if (atomic_add_unless(&inode->i_count, -1, 1)) return;
>>>>> 
>>>>> -	delayed = kmalloc(sizeof(*delayed), GFP_NOFS |
>>>>> __GFP_NOFAIL); -	delayed->inode = inode; - 
>>>>> spin_lock(&fs_info->delayed_iput_lock); -
>>>>> list_add_tail(&delayed->list, &fs_info->delayed_iputs); +
>>>>> list_add_tail(&b_inode->delayed_iput,
>>>>> &fs_info->delayed_iputs); 
>>>>> spin_unlock(&fs_info->delayed_iput_lock); }
>>>> 
>>>> Hmm.  I'm not great with inode life cycles, but isn't this
>>>> only safe if someone else can't get an i_count reference
>>>> while this is in flight?  It looks like the final iput does
>>>> the unhashing, and so on, so couldn't an iget/iput race with
>>>> this and try to add the inode's list_head twice?
>>> 
>>> Yeah, same concern here.  Basically this will result in inodes
>>> still being in use on unmount.
>>> 
>>> Actually I did a similar one, here is some disscussion:
>>> 
>>> https://patchwork.kernel.org/patch/1824711/
>> 
>> I read it, thanks.  Did you try the counter approach?
> 
> Yes, it'll bring a tradeoff situation.
> 
> With counter, we need to lock the list all the time instead of 
> doing a splice on the list and unlocking it.  I think splice would
> be faster so I didn't go further(I MIGHT be wrong on this)..

Thanks for looking into this. I left this note to myself during the
development of the error handling patches while on a tangent to try to
eliminate NOFAIL allocs. It's not the alloc/free that's the issue
(though eliminating these can probably only help), it's that NOFAIL
allocs essentially become locks when memory pressure is high enough
that the NOFAIL functionality gets invoked. OTOH, bailing out of that
path when we encounter an allocation failure is impossible.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJRGfB3AAoJEB57S2MheeWy/E4QALVJ2YI1zbwCHnkUia+yuT40
LoYfyRJoTiKwnwiFeByy98tX9WxVnXGZUVpR8GMwVuLfDIMyVgQmaAicqiirHHHD
ySNV3jsyz8HCOb6ALu7eQyWy4F8yBD1HG75njvvzVO+zUlSsaKGmfvsXS0f4ubCk
hyxg7OujW++cWg+WOedCZsg2n7kF34MLPJiyjS1E1vw8DZW3tHKWgv/hyJIzp+JK
wIZQPrzNUTp0kS4N6+b8rJnXTNkj7zMhWPYeJdIMIG9/+oDr2r1N/XedYMY7fkdS
g7Gj28nmTtufYlTcgztL6MHFwxm/tRQNl85+lRU/zYFKIR0ok4+1kFrpZ5KcF97m
NZeGSsSiaZfMXE+t6B/AgagFJUws+y/RHBJ/V9paMNjsojLRUBVPQOdeHw355XVm
lJeTtyElA+SSawPkzf2115IEj1EgFmHIouSQJdUCPoTfS126NHhH0PYX2GHgAs8b
1ImyG9E/Z/JswVRzAxWGQSffdxzg5Vb8P8w7LzAlIdToVa0tM3Q2n9h3a0vcl83m
NQEqe3+GnsflB2xSVyoztVx+ZL8664HC1UzIjgb7oUihGHe7gJZ4uqDgaClGprKh
pQyvr8zsbjeMwpvlqv7gRQDFyY3JKK4W5UeS/pGjTM7ORS1LmEUTR5S4pQknTUgc
Qj/bH6806My5pW3VB5i5
=ZSdX
-----END PGP SIGNATURE-----
