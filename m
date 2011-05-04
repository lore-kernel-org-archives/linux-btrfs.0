From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: btrfs csum failed
Date: Wed, 4 May 2011 09:23:22 -0400
Message-ID: <000e01cc0a5e$7446eab0$5cd4c010$@nedharvey.com>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at>	<BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>	<4DC13B02.9030604@mur.at> <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com> <4DC1464D.4060204@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: "'Martin Schitter'" <ms@mur.at>, "cwillu" <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC1464D.4060204@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Martin Schitter
> 
> well -- i am doing a backup of all images every night. this process
> should work like a simple "scrub" because all data (and its checksumes)
> will be read. 

Sorry, not correct.  When you read all the data using something in user-land, the OS only needs to read one side of the data.  It can accelerate by staggering the read requests across multiple disks.  So some sectors remain unread on some disks.

When you scrub, it reads all the data from all the redundant copies (mirrored or raid) on all the individual disks in the raid set.  

For this reason, you always want to use JBOD, and don't use hardware raid.  Because if there's an undetected hardware error, the hardware raid will make it impossible for the OS to examine individual disks to identify the failing one.

At least I know all the above is true for reading & scrubbing in another filesystem, I don't actually know any of this for fact in btrfs, but it seems so basic I would be flabbergasted if I learned that wasn't the btrfs behavior.

