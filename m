Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:46381 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbaLHTWu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Dec 2014 14:22:50 -0500
Message-ID: <5485FA86.80102@pobox.com>
Date: Mon, 08 Dec 2014 11:22:46 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Phillip Susi <psusi@ubuntu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <5485C432.3030307@ubuntu.com> <5485E1A0.4030602@gmail.com>
In-Reply-To: <5485E1A0.4030602@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/2014 09:36 AM, Goffredo Baroncelli wrote:
> I like this approach, but as I wrote before, it seems that
> initramfs executes a "btrfs dev scan".... (see my previoue email
> 'Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots'
> date 2014/12/03 9:34):

Roll your own for now. I haven't started doing any significant btrfs 
specific work on it but the initramfs builder in my project 
http://underdog.sourceforge.net might get you past your problem pretty 
easily for now. It would be easy to white/black list which devices you 
want to submit to scan or mount.

It is plumbed up to look at each storage region one-by-one so you could 
assemble your file system that way.

(Note that the eventual point of the project isn't really the initramfs 
stuff but that's what I needed more/first.)

It's fairly well documented and I use it for some non-trivially complex 
systems but its not (yet) so complex that it's hard to design hooks for it.


