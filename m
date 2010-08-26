From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: machine gets unresponsive during btrfs balance
Date: Thu, 26 Aug 2010 15:27:53 +0200
Message-ID: <201008261527.54056.johannes.hirte@fem.tu-ilmenau.de>
References: <4C639F42.3050206@gmail.com> <AANLkTi=B2dr45WmeJop_Te5t55d0trfHP+ZKLE3tBxTg@mail.gmail.com> <4C65C32B.1060109@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: "Yan, Zheng " <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C65C32B.1060109@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 14 August 2010 00:11:55 Andreas Philipp wrote:
> On 12.08.2010 10:04, Yan, Zheng wrote:
> > On Thu, Aug 12, 2010 at 3:14 PM, Andreas Philipp
> > <philipp.andreas@gmail.com> wrote:
> >   
> >> Hi,
> >>
> >> I am using a btrfs filesystem created with raid0 for data and metadata
> >> for (temporary) storage of tv recordings from my vdr. The filesystem was
> >> created under kernel version 2.6.34. An initial btrfs balance command
> >> succeeded. Since I upgraded to 2.6.35-rcX and 2.6.35 btrfs balance no
> >> longer finishes but puts the machine in some unresponsive state.
> >> Unfortunately, I do not see any kernel oops or other debug information
> >> because even the display freezes. The last thing that happens are that
> >> those two lines are written to /var/log/messages:
> >> Aug 11 21:42:23 thor kernel: btrfs: found 62911 extents
> >> Aug 11 21:42:24 thor kernel: btrfs: relocating block group 1723913469952
> >> flags 9
> >> After that the machine becomes immediately unresponsive.
> >>
> >> As I did not see anything that might be related to my problem in the
> >> changelog for 2.6.35.1 I did not try again with this version.
> >>
> >>     
> > Do you have more than one machines? would you please setup netconsole
> > to see what happen.
> >   
> I have reproduced the error on v2.6.35.1 and recorded all kernel output
> with netconsole. The interesting point is that this time the machine did
> not crash but the btrfs balance segfaulted at exact the same position
> where the previous crashes had happened.

Looks like another manifestation of the csum bug. Are you able to read all 
files from the affected volume? Did you tried a balance with an 2.6.34 kernel 
after the test with 2.6.35?

regards,
  Johannes
