Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43540 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2KKPN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 10:13:27 -0500
Received: by mail-wi0-f172.google.com with SMTP id hm6so1790424wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2012 07:13:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509FB5AE.3030504@petaramesh.org>
References: <509ED1D6.8010903@petaramesh.org> <CAGy7Utg5eMfHy+6OghTTDeHznnSvv2Ze11jCecLSLsVEufugeA@mail.gmail.com>
 <509FB2A0.4030504@petaramesh.org> <CAGy7UtgrdGpC5uav0m0yX1oJ47OR6WsX0vOtKu4p5umS4hZUtw@mail.gmail.com>
 <509FB5AE.3030504@petaramesh.org>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Sun, 11 Nov 2012 16:13:05 +0100
Message-ID: <CAGy7Utg1QPk73AxmYSMFc97BN+9yYU0P-wNexvDOhKD6YOR--Q@mail.gmail.com>
Subject: Re: BTRFS cache problem
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 11, 2012 at 3:26 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> I'm not going to take risks with this machine, which is my main laptop
> which I badly need to be in working order tomorrow morning (and #me
> having slept at night... ;-)

Without running different kernels, I don't think we can work with you
to figure out the cause of the problem, unless this is a known problem
(it isn't to me). You didn't mention whether the filesystem actually
mounts properly or not, but if it does then I don't think you'll have
problems other than perhaps diminished performance.

May I also suggest that you maybe shouldn't be running an experimental
filesystem on a laptop that you can't go without?
