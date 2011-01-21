From: CACook@quantum-sci.com
Subject: Re: Adding a disk fails
Date: Fri, 21 Jan 2011 11:16:34 -0800
Message-ID: <201101211116.35290.CACook@quantum-sci.com>
References: <201101201318.40686.CACook@quantum-sci.com> <201101201510.54418.CACook@quantum-sci.com> <4D39D39F.5040806@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D39D39F.5040806@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 21 January 2011 10:42:39 Goffredo Baroncelli wrote:
> > Thanks Goffredo but as I say, I did this and it responds with 
> >  "ERROR: error adding the device '/dev/sdc'"
> > .. it doesn't give a clue.
> 
> In your email you wrote that before adding the device you format it.
> Anyway I don't think that this is the problem.
> 
> Have you check which is reported in dmesg.

Absolutely no sign of a problem in dmesg or the logs.


> >> btrfs device scan
> > 
> > This must be done at every boot?  If so, where is recommended, in rc.local? 
> 
> Look at this thread, where I wrote anout a possible solution
> 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04709.html

Thanks.  I am suspecting scan is built into Debian.  Not sure what to look for though, with all the darned variables.


> > 2.6.32-5-amd64 with Debian patches.
> 
> From a btrfs point of view, it is a very old kernel. IIRC in this kernel
> is not supported the snapshot removal. I suggest you to update the
> kernel with a recent one.

I've looked for a newer kernel sources, but there isn't one with Debian patches.  I always compile my kernel.



