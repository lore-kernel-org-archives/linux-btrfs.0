Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.idedalo.net ([178.33.75.195]:48176 "EHLO mx1.idedalo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbeIOB3L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 21:29:11 -0400
Subject: Re: Problem with BTRFS
To: Nicholas D Steeves <nsteeves@gmail.com>, Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
References: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
 <20180914224612.07a5db1b@natsu>
 <20180914181818.rnef5ml3wgelwjm5@DigitalMercury.dynalias.net>
From: =?UTF-8?Q?Rafael_Jes=c3=bas_Alc=c3=a1ntara_P=c3=a9rez?=
        <ralcantara@idedalo.com>
Message-ID: <3dcb98e2-a3e5-4166-a4e0-42dddf6b7080@idedalo.com>
Date: Fri, 14 Sep 2018 22:13:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180914181818.rnef5ml3wgelwjm5@DigitalMercury.dynalias.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It seems that btrfs-progs_4.17-1 from Sid, includes that feature (at
least, it says so in the manual page). I don't know if I can install it
on Stretch but I'll try.

Greets and thank you very much to both of you ;)
Rafael J. Alcántara Pérez.

El 14/09/18 a las 20:18, Nicholas D Steeves escribió:
> Hi,
> 
> On Fri, Sep 14, 2018 at 10:46:12PM +0500, Roman Mamedov wrote:
>> On Fri, 14 Sep 2018 19:27:04 +0200
>> Rafael Jesús Alcántara Pérez         <ralcantara@idedalo.com> wrote:
>>
>>> BTRFS info (device sdc1): use lzo compression, level 0
>>> BTRFS warning (device sdc1): 'recovery' is deprecated, use
>>> 'usebackuproot' instead
>>> BTRFS info (device sdc1): trying to use backup root at mount time
>>> BTRFS info (device sdc1): disk space caching is enabled
>>> BTRFS info (device sdc1): has skinny extents
>>> BTRFS error (device sdc1): super_total_bytes 6010266660864 mismatch with
>>> fs_devices total_rw_bytes 6010266663424
>>
>> There is a recent feature added to "btrfs rescue" to fix this kind of
>> condition: https://patchwork.kernel.org/patch/10011399/
>>
>> You need a recent version of the Btrfs tools for it, not sure which, I see
>> that it's not in version 4.13 but is present in 4.17.
> 
> btrfs-progs_4.17-1~bpo9+1_amd64.changes is waiting to pass through NEW
> (due to the new library packages in the backport).  It will take
> between 24h and several weeks to pass to stretch-backports.  The
> variability in expected delivery is because a Debian FTP Master will
> need to manually ACK the changes.
> 
> If 4.17.1 is required, please 'reportbug btrfs-progs' and take care to
> set the "found" version to 4.17-1, plus provide a citation for why
> 4.17.1 is required--without this justification the bug severity could
> be downgraded to wishlist.  This hypothetical bug would be for the
> "unstable" suite (packages migrate to testing after a period of
> testing, and then become eligible for backporting).
> 
> Take care!
> Nicholas
> 


-- 
