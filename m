From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Various Questions
Date: Sun, 9 Jan 2011 05:16:08 -0800
Message-ID: <201101090516.09255.CACook@quantum-sci.com>
References: <201101070915.20468.CACook@quantum-sci.com> <201101080525.19792.CACook@quantum-sci.com> <AANLkTi=HPx1-e09kPg0c6_UQpTCOfPe6-Q4SOUxKLnE=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=HPx1-e09kPg0c6_UQpTCOfPe6-Q4SOUxKLnE=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


I'd rather not do the copy again unless necessary, as it took a day.

Directories look identical, but who knows?  I'm going to try and figure out how to do a file-by-file crc check, for peace of mind.


On Sat 08 January 2011 17:26:25 Freddie Cash wrote:
> On Sat, Jan 8, 2011 at 5:25 AM, Carl Cook <CACook@quantum-sci.com> wrote:
> >
> > In addition to the questions below, if anyone has a chance could you advise on why my destination drive has more data  than the source after this command:
> > # rsync --hard-links --delete --inplace --archive --numeric-ids /media/disk/* /home
> > sending incremental file list
> 
> What happens if you delete /home, then run the command again, but
> without the *?  You generally don't use wildcards for the source or
> destination when using rsync.  You just tell it which directory to
> start in.
> 
> If you do an "ls /home" and "ls /media/disk" are they different?
> 
> 
