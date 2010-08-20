From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 20:56:17 +0200
Message-ID: <201008202056.18041.kreijack@libero.it>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com> <AANLkTi=fgMC2h86cJQzyHRzUF0M0eSMdoWFtrWrjHorc@mail.gmail.com> <AANLkTikmka7G-+bCLeqKmQQXbBJp=GkHJDApYpup5t-d@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikmka7G-+bCLeqKmQQXbBJp=GkHJDApYpup5t-d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 20 August, 2010, Benjamin Griese wrote:
> Hello guys,
> 
> I would also prefer doing it in an all-in-one tool with various parameters.
> I like the concept how the Solaris-Devs did it by consolidating every
> special configuration tool to an "xyzadm"-binary (idea: btrfsadm? i.e.
> similar to mdadm?).
> For me as an admin it is easier to remember only one command,
> especially when its neccessery to use it only from time to time.
> There exists only one manpage where every parameter is found (in theory). 
:)
> And for the devs (sorry, I'm not one of those guys ;) ) maybe its
> easier to maintain/improve only one binary + lib.
> 
> Just my opinion. :)

This is the reason of btrfs command. The aim of this command (which is quite 
new) is to groups all the btrfs related command. In fact, the btrfs command  
is able to replace btrfs-show, btrfs-vol, btrfsctl, which may be considered 
"obsolete". 
Regarding the other commands:

* btrfs-debug-tree, btrfs-map-logical, btrfs-image: are debugging commands. 
Not useful to a system administrator
* btrfsck: historically the fsck* program is a standalone program. And the 
btrfs one is not useful at all.
* mkfs.btrfs: same as above
* btrfs-convert, btrfstune: may be possible candidate for an inclusion in the 
btrfs program

But what is needed is not the request but the codes :-)


Regards
Goffredo

> 
> bye, benjamin
> 
> 
> On Fri, Aug 20, 2010 at 14:43, Jon Nelson <jnelson@jamponi.net> wrote:
> > On Fri, Aug 20, 2010 at 7:03 AM, Goffredo Baroncelli <kreijack@gmail.com> 
wrote:
> >>
> >>
> >> +                       fprintf(stderr, "ERR-A.11: in command '");
> >>
> >> I am not against this kind of error codes, but I prefer
> >>
> >> +                       fprintf(stderr, "Error 'ERR-A.11' in command 
'");
> >>
> >> And a file.txt which details the error codes (otherwise these errors are 
not
> >> very useful).
> >>
> >> Why some error codes contain a dot (see ERR-C.13) and others not (like 
ERR-
> >> A3) ?
> >
> > Goffredo Baroncelli - I think those are good comments!
> >
> > However, I would further suggest that when reporting an error code
> > that including the 'ERR-' prefix is redundant. Therefore, I propose:
> >
> > fprintf(stderr, "Error 'A.11' in command '");
> >
> > What does A. 11 refer to, anyway?
> >
> > --
> > Jon
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> To be or not to be -- Shakespeare | To do is to be -- Nietzsche | To
> be is to do -- Sartre | Do be do be do -- Sinatra
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
