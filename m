Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw2.netgear.com ([209.249.181.7]:57127 "EHLO
	mailgw2.netgear.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaBLD23 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 22:28:29 -0500
From: Kostia Khlebopros <kkhlebopros@netgear.com>
To: Sandy McArthur <sandymac@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>
Subject: RE: What to do about df and btrfs fi df
Date: Wed, 12 Feb 2014 03:09:52 +0000
Message-ID: <C4D5B07324A04D4784C9F6D0FB2B0C336FFA9CA2@PERSES.netgear.com>
References: <52F9014F.6070901@fb.com>
 <CAPs0BigohtKrGW9MKGZzPrc_rUxkHDhtS-XcL-TzxEQgE-qZ4Q@mail.gmail.com>
In-Reply-To: <CAPs0BigohtKrGW9MKGZzPrc_rUxkHDhtS-XcL-TzxEQgE-qZ4Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any plans on having "brtfs fi df" report more precise values rather then rounded off to the nearest hundredth of a unit. full kilobytes(1024 bytes =1Kib) or in bytes would be nice

Current output:

# btrfs fi df /data
Data, single: total=1.37TiB, used=1.35TiB
System, DUP: total=8.00MiB, used=192.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=3.00GiB, used=1.62GiB
Metadata, single: total=8.00MiB, used=0.00

Better would be:

# btrfs fi df /data
Data, single: total=14123412341 bytes, used=1342343 bytes
...etc you know what I mean...

I wish there was more you know.

Kind Regards,

Kostia

ï Consider the environment. Please don't print this e-mail unless you really need to.

-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Sandy McArthur
Sent: Tuesday, February 11, 2014 12:54 PM
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik
Subject: Re: What to do about df and btrfs fi df

Maybe this is too much of a break from tradition but I think df should report the min(device free space, remaining quota) for the particular volume being queried.


On Mon, Feb 10, 2014 at 11:41 AM, Josef Bacik <jbacik@fb.com> wrote:
> Hello,
>
> So first of all this is going to get a lot of responses, so straight 
> away I'm only going to consider your opinion if I recognize your name 
> and think you are a sane person.  This basically means any big 
> contributors and we'll make sanity exceptions for cwillu.
>
> These are just broad strokes, let us not get bogged down in the 
> details, I just want to come to a consensus on how things _generally_ 
> should be portrayed to the user.  We can worry about implementation 
> details once we agree on the direction we want to go.
>
> We all know space is a loaded question with btrfs, so I'm just going 
> to explain the reasoning of why we chose what we chose originally and 
> then offer the direction we should go in.  If you agree say yay, if 
> not please provide a very concise alternative suggestion with a very 
> short explanation of why it is better than I'm suggesting.  I'm not 
> looking to spend a whole lot of time this problem.
>
> Also this isn't going to address b_avail, cause frankly that is some 
> fucking voodoo right there, suffice it to say we will just adjust 
> b_avail based on how we should represent total and used.
>
> ===== ye olde df =====
>
> I don't remember what we did originally, but IIRC we would only show 
> used space from the block groups and would show the entire size of the 
> fs.  So for example with two 1 tb drives in RAID1 you'd see ENOSPC and 
> look at df and it would show total of 2TB and used at 1TB.  Obviously 
> not good, so we switched to the mechanism we have today, which is you 
> see 2TB for total, you see 2TB for used and you see 0 for available.  
> We just scaled up the used and available based on your raid multiplier.
>
> ===== btrfs fi df =====
>
> I made this for me because of ENOSPC issues but of course it's also 
> really useful for users.  It is just a dump of the block group 
> information and their flags, so really just spits out bytes_used and total_bytes and flags.
> Because at the block_group/space_info level in btrfs we don't care 
> about how much actual space is taken up this number is not adjusted 
> for RAID values, and these numbers are reflected in the tools output.  
> So if you have RAID1 you need to mentally multiply the Total and Used 
> values by 2 because that is how much actual space is being used.
>
> =====  What to do moving forward =====
>
> Flip what both of these do.  Do not multiply for normal df, and 
> multiply for btrfs fi df.
>
> ===== New and improved df =====
>
> Since this is the lowest common denominator we should just spit out 
> how much space is used based on the block groups and then divide the 
> remaining space that hasn't been allocated yet by the raid multiplier.
>
> This is going to be kind of tricky once we do per-subvolume RAID 
> levels, but this falls under the b_avail voodoo which is just a guess 
> anyway, so for this we will probably take the biggest multiplier and 
> use that to show how much available space you have.
>
> This way with RAID1 it shows you have 1tb of total space and you've 
> used 1tb of space.
>
> ===== New and improved btrfs fi df =====
>
> Since people using this tool are already going to be better informed 
> and since we are already given the block group flags we can go ahead 
> and do the raid multiplier in btrfs-progs and spit out the adjusted 
> numbers rather than the raw numbers we get from the ioctl.  This will 
> just be a progs thing and that way we can possibly add an option to 
> not apply the multipliers and just get the raw output.
>
> ===== Conclusion =====
>
> Let me know if this is acceptable to everybody.  Remember this is just 
> broad strokes, keep your responses short and simple or I simply won't read them.
> Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html



--
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 2013.0.3462 / Virus Database: 3697/7079 - Release Date: 02/09/14

This e-mail, including attachments, may include confidential 
and/or proprietary information, and may be used only by the 
person or entity to which it is addressed.
If the reader of this e-mail is not the intended recipient or his or 
her authorized agent, the reader is hereby notified that any 
dissemination, distribution or copying of this e-mail is prohibited. 
If you have received this e-mail in error, please notify the sender 
by replying to this message and delete this e-mail immediately
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
