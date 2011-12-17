From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 12:57:32 +0100
Message-ID: <201112171257.33141.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112171238.07681.Martin@lichtvoll.de> <20111217114508.GE17573@carfax.org.uk> (sfid-20111217_125531_210037_B5B3D3DB)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: Hugo Mills <hugo@carfax.org.uk>,
	Sergei Trofimovich <slyich@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111217114508.GE17573@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Hugo Mills:
> > >    The metadata trees are automatically balanced, simply by the
> > >nature
> > >
> > > of the B-tree algorithms used. Balance won't, in general, affect
> > > them. The only thing that a balance will achieve on a single-disk
> > > filesystem is to reclaim unused space from allocated block groups
> > > -- so the "total" value in your Data and Metadata entries below
> > > will go down.
> >
> > 
> >
> > But thats only for optical viewing pleasure as far as I understood
> > you?
> >
> > 
> >
> > Only if there would be not enough free space for one tree to extend
> > then a  balance would make sense? I.e. when I had a lot of metadata
> > so that the metadata would need to extend (which seems unlikely
> > given below figures).
> 
>    From the context, I think you're misusing the term "tree" here to
> mean "block group type" (i.e. data or metadata).
> 
>    That aside, though, yes, you're right, it's effectively only
> cosmetic -- although it can be useful if you have a fully-allocated
> filesystem where (for example) data is full and there's lots of
> metadata space free, and you want to write more data. In that case,
> the FS wants to allocate another Data block group, but can't because
> there's no raw storage left to allocate from, despite there being lots
> of free space in the allocated Metadata block groups. A balance in
> that case would free up some of the metadata block groups and allow
> that space to be reallocated as data. (I think it tries to do this
> anyway, but I'm not 100% sure about that).

Okay, thats the more likely case then ;).

Thanks for clearing that up,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
