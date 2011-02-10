From: Eduardo Silva <eduardo.silva@oracle.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 10:41:17 -0300
Message-ID: <1297345277.28159.15.camel@monotop>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se>
	 <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	 <ij0iku$hbq$1@dough.gmane.org>
	 <AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com>
	 <1297344585.28159.12.camel@monotop>
	 <AANLkTik0stPo-_s-n8ndZUiwYcZ51V6m29x1X56q8AYd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jeremy Sanders <jeremy@jeremysanders.net>,
	linux-btrfs@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik0stPo-_s-n8ndZUiwYcZ51V6m29x1X56q8AYd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-02-10 at 14:34 +0100, Olaf van der Spek wrote:
> On Thu, Feb 10, 2011 at 2:29 PM, Eduardo Silva <eduardo.silva@oracle.com> wrote:
> >> > There's strlcpy, but it's not in glibc because of possible truncation
> >> > errors!
> >>
> >> Then use a private wrapper.
> >>
> >
> > Here's the new patch:
> >
> > ----
> > [PATCH] Add safe string manipulation functions
> >
> > Deprecate direct use of strcpy(3)
> > The following string manipulation function has been added:
> >
> >   - string_copy() : wrapper of strcpy(3)
> >   - string_ncopy(): wrapper of strncpy(3)
> >
> > both function compose safe NULL terminated strings.
> > ----
> >
> > I check that the code most of the time raise an error if the path is too
> > long, so the new wrappers should be ok...
> 
> string_copy seems pointless, it's kinda equivalent to strcpy.

got your point, but If we are creating wrappers for string manipulation,
let's do it for the most common functions used.

> if (!dest || !src) should include an assert so it's easier to break in
> the debugger.
> 
  good one

regards, 

Ed.-

