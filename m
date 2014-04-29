Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53126 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbaD2RKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 13:10:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfBYJ-0003TK-BF
	for linux-btrfs@vger.kernel.org; Tue, 29 Apr 2014 19:10:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 19:10:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 19:10:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/14] Enhanced df - followup
Date: Tue, 29 Apr 2014 17:10:31 +0000 (UTC)
Message-ID: <pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
References: <cover.1398786620.git.dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Tue, 29 Apr 2014 17:56:47 +0200 as excerpted:

> Changes:
> * btrfs filesystem disk_usage - renamed to usage

Hopefully this isn't rehashing an old discussion, but...

Simpler is good, and getting rid of the _ is good, but...

To users familiar with Unix/POSIX/Linux CLI, "usage" (as --usage) is most 
often seen as a rather less common and generally briefer form of --help, 
usually with the distinction being that --help may be a screen or more of 
output, while --usage is much shorter, perhaps a single line.

While I had seen it listed in manpages and --help output often enough, 
once I actually went looking for real examples I had a hard time finding 
some, but eventually found some in the grub (grub2) command set.

$ grub-bios-setup --usage
Usage: grub-bios-setup [-afsv?V] [-b FILE] [-c FILE] [-d DIR] [-m FILE]
            [--allow-floppy] [--boot-image=FILE] [--core-image=FILE]
            [--directory=DIR] [--force] [--device-map=FILE] [--no-rs-
codes]
            [--skip-fs-probe] [--verbose] [--help] [--usage] [--version]
            DEVICE

(For brevity, just printing the line-count for the following few example 
grub-* commands, not the full output.)

$ grub-bios-setup --help | wc -l
30

$ grub-probe --usage | wc -l
3

$ grub-probe --help | wc -l
23

$ grub-editenv --usage | wc -l
2

$ grub-editenv --help | wc -l
23


While --usage does normally appear with the usual long-option double-dash 
and the proposal for btrfs does not, I'd still consider a simple
"btrfs filesystem usage" confusing at best, expecting it to print out a 
short help/usage for the "btrfs filesystem" command, either due to not 
understanding the token and thus printing command usage, or understanding 
it as a request to print command usage, NOT the actual filesystem usage.

OTOH, for CLI veterans anyway, standard old "du" (btrfs fi du) should be 
as immediately understood as "df".


Given that confusion, I'd suggest either simply making it du, or making 
it "device_usage" but with "du" a documented alias printing exactly the 
same output, thus giving folks an easy way to avoid the _.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

