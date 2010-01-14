From: Chris Mason <chris.mason@oracle.com>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Wed, 13 Jan 2010 20:07:09 -0500
Message-ID: <20100114010709.GD3428@think>
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
 <20100110201926.GC32195@think>
 <201001132337.34909.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755309Ab0ANBHo@vger.kernel.org>
In-Reply-To: <201001132337.34909.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 11:37:33PM +0100, Johannes Hirte wrote:
> Am Sonntag 10 Januar 2010 21:19:26 schrieb Chris Mason:
> > On Sun, Jan 10, 2010 at 09:05:46PM +0100, Johannes Hirte wrote:
> > > I've observed this hanging task now several times. Not sure when this
> > > started, but 2.6.32 is affected too, IIRC. I don't have a test pattern
> > > for this. Dovecot imap triggers this from time to time. I've enabled
> > > CONFIG_DETECT_HUNG_TASK now
> > 
> > > and got this two tasks which hang:
> > You're stuck on a read, could you please do a sysrq-w when this happens?
> 
> Will do so when it happens again.

No need, I reread the trace, you're stuck in copy_from_user and probably
hitting a deadlock in the btrfs page faulting path.  This is pretty
rare, but I'll put it into the queue to fix up.
> 
> > Also, do you eventually recover or are you stuck forever?
> 
> I didn't wait too long when it happened, so I'm not sure.  The longest time 
> I've waited was 20-30min, until reboot without recover. So either it's stuck 
> forever or it takes really long to recover.
> 
> And one question I have: How do you identify a read in this call trace? 

Lock page followed by sync page is usually for reading.

-chris
