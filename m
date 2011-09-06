From: Dante <danteinbrisbane@gmail.com>
Subject: RE: Any chance to recovery btrfs raid-0 after accidental format of
 one volume?
Date: Wed, 7 Sep 2011 09:00:21 +1000
Message-ID: <CAKdoYmDv0GcEKOnkjMuZG40VtR2KzzzwVu33srr8a-taJ_VhQQ@mail.gmail.com>
References: <CAKdoYmDNjBDgHjLNaf5HmrRxGkYPXjssZoGa3Tb4p3uc2DcOcg@mail.gmail.com>
	<CAKdoYmAsSa5Qdp_S_XrhVjHyDhGwmNcH=Vw0wFq0oRMvm0medA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKdoYmAsSa5Qdp_S_XrhVjHyDhGwmNcH=Vw0wFq0oRMvm0medA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> > Bad case of user error here but I managed to reformat one half of a
> > btrfs volume that was set up with metadata raid-1 and data raid-0.

> It won't help you - but did you format it with mkfs.btrfs, while it was mounted?

No I formatted as ext4 while off-line.

Thanks for the feedback.

I guess I just kiss the files goodbye and move on.
