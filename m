Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42973 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3GQVtF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 17:49:05 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so1959574lbv.13
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 14:49:04 -0700 (PDT)
Received: from mail-lb0-x22d.google.com (mail-lb0-x22d.google.com [2a00:1450:4010:c04::22d])
        by mx.google.com with ESMTPSA id m14sm3436631lbl.1.2013.07.17.14.43.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 17 Jul 2013 14:43:56 -0700 (PDT)
Received: by mail-lb0-f173.google.com with SMTP id v1so1964052lbd.18
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 14:43:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E7044C.2030805@giantdisaster.de>
References: <CABZ+qqnM4g9H1d4dCw9Ao3Kj7tKGJ7M1_oPkGjFKcheMrD=HMQ@mail.gmail.com>
 <CABZ+qqmm4X7FEWr=BuPwF_uPJ8Rdg9Le3d-iLnYfB+if3N-mzQ@mail.gmail.com> <51E7044C.2030805@giantdisaster.de>
From: Dan van der Ster <dan@vanderster.com>
Date: Wed, 17 Jul 2013 23:43:15 +0200
Message-ID: <CABZ+qqmrL1VuBF=oqd8nMONu2N4it76UWrZyx-6TFGYUZuCWnQ@mail.gmail.com>
Subject: Re: unfinished convert to raid6, enospc
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 17, 2013 at 10:53 PM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> No protection against ... disk failures

Well I was aware of the power loss and scrub issues, but not the lack
of protection against disk failures. That sorta defeats the purpose.
Back to RAID 1 I go then...
thanks :)
