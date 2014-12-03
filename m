Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLCTRo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 14:17:44 -0500
Date: Wed, 3 Dec 2014 20:17:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203191743.GA12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <547D663A.3020201@jp.fujitsu.com>
 <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com>
 <547E5544.7090907@jp.fujitsu.com>
 <CAH-HCWXBEkR3uVr7SPoiuYx2bSbrWQvvE=BWDw-5b+j7HES8+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWXBEkR3uVr7SPoiuYx2bSbrWQvvE=BWDw-5b+j7HES8+g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 03, 2014 at 08:05:08AM +0530, Shriramana Sharma wrote:
> On Wed, Dec 3, 2014 at 5:41 AM, Satoru Takeuchi
> <takeuchi_satoru@jp.fujitsu.com> wrote:
> > 2. You delete /snap by "snapper delete" command by mistake.
> >    Then snapper takes a "pre" snapshot just before deleting
> >    /snap.
> > 3. Now /snap is deleted, however, a "pre" snapshot which is
> >    the same as /snap before deleting, is still alive.
> >
> > I don't know how Btrfs itself undo the deletion of a snapshot.
> > It works if you manages snapshots not by btrfs directly,
> > but by snapper.
> >
> > If I misunderstanding something, sorry for noise.
> 
> No nothing misunderstood. Excellent illustration. So using snapper is
> sorta like using the higher-level trash instead of lower-level rm, so
> that even after we "delete", it's still available...

I think there's some confusion, please refer to snapper documentation.
