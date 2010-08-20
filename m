From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 21:03:40 +0200
Message-ID: <201008202103.40519.kreijack@libero.it>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com> <4C6ECAA3.6010601@gmail.com> <AANLkTikuDusJPbd9QZA80mgvHWVV+y+Q-=qcn1kXq8et@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikuDusJPbd9QZA80mgvHWVV+y+Q-=qcn1kXq8et@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 20 August, 2010, Josh Berry wrote:
> On Fri, Aug 20, 2010 at 11:34, Andreas Philipp
> <philipp.andreas@gmail.com> wrote:
> >  On 20.08.2010 20:27, Josh Berry wrote:
> >>
> >> On Fri, Aug 20, 2010 at 05:03, Goffredo Baroncelli<kreijack@gmail.com>
> >>  wrote:
> >>>
> >>> On Thursday, 19 August, 2010, James Smith wrote:
> >>>>
> >>>> This patch randomizes the error codes and also fixes up some typos
> >>>
> >>> including
> >>>>
> >>>> capitalization in the output.
> >>>>
> >>>> It would almost be nice to see a translation effort for the tool as
> >>>> well.
> >>
> >> [...]
> >>>
> >>> +                       fprintf(stderr, "ERR-A.11: in command '");
> >>>
> >>> I am not against this kind of error codes, but I prefer
> >>>
> >>> +                       fprintf(stderr, "Error 'ERR-A.11' in command 
'");
> >>
> >> As a layman/end user, I disagree.  The former format is easier for
> >> shell scripts and the like to parse -- the error code can be extracted
> >> with a simple "cut -d: -f1".
> >
> > This makes no difference. A simple `cut -d " " -f1` would do the job in 
the
> > second case.
> 
> I think you meant -f2, and that still leaves the quotes hanging
> around.  So you'd need to cut -d" " -f2 |tr -d "'" .  It's not a big
> deal either way, I just think the former is easier to work with.


Why do not use the exit() return value ? My goal when I wrote btrfs, was a 
clean up of the returned codes. The btrfsctl command (the old command) is a 
mess regarding this aspect. But btrfs should (modulo BUG) return 0 for a 
successful action and a value different to 0 for an error. I agree that these 
codes have to be documented in the man page.

> 
> -- Josh
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
