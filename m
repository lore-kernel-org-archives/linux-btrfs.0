From: Gerhard Kulzer <gerhard@kulzer.net>
Subject: Re: system crash at mounting of btrfs
Date: Fri, 8 Oct 2010 17:04:33 +0000 (UTC)
Message-ID: <loom.20101008T190047-257@post.gmane.org>
References: <4CAEBD78.7000002@wpkg.org> <loom.20101008T182314-909@post.gmane.org> <20101008165347.GR4804@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> oracle.com> writes:

> 
> So this is a completely different race from the first one.  Do you get
> the same crashes every time you try to boot or are they different every
> time?
> 
> We can definitely help get the data off.
> 
> -chris
> 
Thanks Chris,
the first trace was from dmesg during boot where it actually did not mount the
btrfs partition but just "saw" it during boot. The system continued running.

The last trace is the one that occurs when I try to mount the system, and it
dies with it. 

