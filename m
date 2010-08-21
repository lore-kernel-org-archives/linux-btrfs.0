From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Sat, 21 Aug 2010 11:37:12 +0200
Message-ID: <201008211137.12565.kreijack@libero.it>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com> <AANLkTik=t4mWvSOzLbFR3M7RbxgS=9WAFraj3XUguMLF@mail.gmail.com> <AANLkTinrujaWqN8NLNdaydL=ENOrMEgb9cjWdDD_g6GT@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinrujaWqN8NLNdaydL=ENOrMEgb9cjWdDD_g6GT@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 21 August, 2010, James Smith wrote:
[...]
> I'll look at a error.txt file (after finding convention) and also
> update the man. In regards to shortening of dev/device -- is this
> really neccessary? And what harm does this cause in the first place?
> In device add-delete functionality.

Make sense to rename <dev> in <device> for the "btrfs add/delete" commands


> 
> 
> On 8/20/10, Josh Berry <des@condordes.net> wrote:
> > On Fri, Aug 20, 2010 at 12:00, Andreas Philipp
> > <philipp.andreas@gmail.com> wrote:
> >>  On 20.08.2010 20:49, Josh Berry wrote:
> >>>
> >>> On Fri, Aug 20, 2010 at 11:34, Andreas Philipp
> >>> <philipp.andreas@gmail.com>  wrote:
> >>>>
> >>>>  On 20.08.2010 20:27, Josh Berry wrote:
> >>>>>
> >>>>> On Fri, Aug 20, 2010 at 05:03, Goffredo 
Baroncelli<kreijack@gmail.com>
> >>>>>  wrote:
> >>>>>>
> >>>>>> On Thursday, 19 August, 2010, James Smith wrote:
> >>>>>>>
> >>>>>>> This patch randomizes the error codes and also fixes up some typos
> >>>>>>
> >>>>>> including
> >>>>>>>
> >>>>>>> capitalization in the output.
> >>>>>>>
> >>>>>>> It would almost be nice to see a translation effort for the tool as
> >>>>>>> well.
> >>>>>
> >>>>> [...]
> >>>>>>
> >>>>>> +                       fprintf(stderr, "ERR-A.11: in command '");
> >>>>>>
> >>>>>> I am not against this kind of error codes, but I prefer
> >>>>>>
> >>>>>> +                       fprintf(stderr, "Error 'ERR-A.11' in command
> >>>>>> '");
> >>>>>
> >>>>> As a layman/end user, I disagree.  The former format is easier for
> >>>>> shell scripts and the like to parse -- the error code can be 
extracted
> >>>>> with a simple "cut -d: -f1".
> >>>>
> >>>> This makes no difference. A simple `cut -d " " -f1` would do the job 
in
> >>>> the
> >>>> second case.
> >>>
> >>> I think you meant -f2, and that still leaves the quotes hanging
> >>> around.  So you'd need to cut -d" " -f2 |tr -d "'" .  It's not a big
> >>> deal either way, I just think the former is easier to work with.
> >>
> >> Sorry, of course -f2. But why not simply cut -d "'" -f 2?
> >
> > Oh right, good point. :)  Though as Goffredo said, using the error
> > code is probably better anyway.
> >
> > -- Josh
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
