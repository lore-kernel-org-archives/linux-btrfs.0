Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47507 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab3DANbN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 09:31:13 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 946FE7C04FA
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 07:31:12 -0600 (MDT)
Date: Mon, 1 Apr 2013 09:31:10 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roman Mamedov <rm@romanrm.ru>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already exists
Message-ID: <20130401133110.GH1876@localhost.localdomain>
References: <20130401041540.4b8a4ab3@natsu>
 <20130401043605.2eb250a7@natsu>
 <20130401141207.533886a2@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130401141207.533886a2@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 01, 2013 at 02:12:07AM -0600, Roman Mamedov wrote:
> On Mon, 1 Apr 2013 04:36:05 +0600
> Roman Mamedov <rm@romanrm.ru> wrote:
> 
> > Hello,
> > 
> > After a reboot the filesystem now does not mount at all, with similar messages.
> 
> So thinking this was an isolated incident, I foolishly continued setting up
> scheduled balance on other systems with btrfs that I have.
> 
> And got into exactly the same situation on another machine!!
> 
> Trying to balance this with -dusage=5, on kernel 3.8.5:
> 
> Data: total=215.01GB, used=141.76GB
> System, DUP: total=32.00MB, used=32.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=9.38GB, used=1.09GB
> 
> Same messages, "Object already exists".
> 
> While I currently left the previously mentioned 2TB FS in an unmounted broken
> state, still waiting for any response from you on how to properly recover from
> this problem, in this new case I needed to restore the machine as soon as
> possible.
> 
> I tried btrfsck --repair, it corrected a lot of errors, but in the end gave up
> with a message saying that it can't repair the filesystem; then I did
> btrfs-zero-log. After this the FS started mounting successfully again.
> 
> Not sure if I got any data corruption as a result, but this is the root FS
> and /home, and the machine successfully booted up with no data lost in any of
> the apps that were active just before the crash (e.g browser, IM and IRC
> clients), so probably not.
> 

Can you capture an image of these broken file systems the next time it happens?
You'll need to clone the progs here

git://github.com/josefbacik/btrfs-progs.git

and build and then run

btrfs-image -w /dev/whatever blah.img

and then upload blah.img up somewhere I can pull it down.  You can use the -t
and -c options too, but the -w is the most important since you have extent tree
corruption.  Thanks,

Josef
