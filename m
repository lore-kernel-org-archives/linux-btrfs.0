From: Robert Millan <rmh@aybabtu.com>
Subject: Re: grub-0.97: btrfs multidevice support [PATCH]
Date: Sun, 27 Sep 2009 12:18:04 +0200
Message-ID: <20090927101804.GA22642@thorin>
References: <4ABBC1F5.70808@redhat.com> <20090924202146.GA16412@thorin> <20090924223810.GA2638@brong.net> <20090925140951.GA6318@thorin> <20090925150136.GQ13423@riva.ucam.org> <6149e97b0909262029w30fe3adcq591515f0f2b156c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Colin Watson <cjwatson@ubuntu.com>,
	Bron Gondwana <brong@fastmail.fm>,
	Ric Wheeler <rwheeler@redhat.com>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: The development of GRUB 2 <grub-devel@gnu.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6149e97b0909262029w30fe3adcq591515f0f2b156c4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 27, 2009 at 11:29:11AM +0800, Peng Tao wrote:
> >
> > It would be great if somebody could take up Edward's work and port it to
> > GRUB 2. If nobody else does then I'd be interested in doing so myself,
> > although I will not be able to start for a month or two from now.
> Is there any guild lines for porting GPLv2 code to GRUB2? I've looked
> at the GRUB2 wiki but very few things are documented there
> (http://grub.enbug.org/). I'd like to see what it would take to port
> the patches. If I can afford it, I'd like to try.

I assume you mean GPLv2-only code (as opposed to GPLv2-or-later). First
step would be to contact the copyright holders and ask them to relicense
under v3-compatible terms (e.g. GPLv2-or-later).  Chances are they didn't
chose these terms as an act of hostility, but were simply being zealous
about allowing something before they knew what it is.

If that doesn't work, we'll always have Par^W clean room
(http://en.wikipedia.org/wiki/Clean_room_design).

-- 
Robert Millan

  The DRM opt-in fallacy: "Your data belongs to us. We will decide when (and
  how) you may access your data; but nobody's threatening your freedom: we
  still allow you to remove your data and not access it at all."
