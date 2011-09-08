From: Justin Gottula <justin@jgottula.com>
Subject: Re: Btrfs moved my root tree off the end of the device
Date: Thu, 8 Sep 2011 00:29:43 -0700
Message-ID: <CAKuMfTV4ck_wCVb-EfMQ05t_9ziLx_He30uL6wARn_17pZs2hw@mail.gmail.com>
References: <loom.20110908T005218-836@post.gmane.org> <4E6857DB.4020604@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E6857DB.4020604@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 7, 2011 at 10:51 PM, Arne Jansen <sensille@gmx.net> wrote:
> I think Liu Bo posted a fix for this a while ago:
>
> [PATCH] Btrfs: fix a bug of balance on full multi-disk partitions
>
> -Arne

The behavior that this patch describes looks pretty much exactly like
what I was seeing, although in my situation the reason for the
relocation was due to defragging rather than multi-device balancing
(not sure if that ultimately makes any difference based on what he's
saying is responsible for the problem). I may be able to find a way to
reliably reproduce the buggy behavior, and if so, I'll try the
bleeding edge git kernel (which appears to have this patch by now) and
see if the problem goes away.


Justin
