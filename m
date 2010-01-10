From: Chris Mason <chris.mason@oracle.com>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Sun, 10 Jan 2010 15:19:26 -0500
Message-ID: <20100110201926.GC32195@think>
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 10, 2010 at 09:05:46PM +0100, Johannes Hirte wrote:
> I've observed this hanging task now several times. Not sure when this started, 
> but 2.6.32 is affected too, IIRC. I don't have a test pattern for this. Dovecot 
> imap triggers this from time to time. I've enabled CONFIG_DETECT_HUNG_TASK now 
> and got this two tasks which hang:

You're stuck on a read, could you please do a sysrq-w when this happens?
Also, do you eventually recover or are you stuck forever?

-chris
