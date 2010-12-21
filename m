From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
Date: Tue, 21 Dec 2010 03:07:33 +0200
Message-ID: <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
References: <20101220222446.GA8629@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101220222446.GA8629@hexapodia.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> I have a directory with 1.2M files in it, which makes readdir very slow
> on btrfs with cold caches (although it's reasonably fast with hot caches
> as in the first example below):

Sounds like:

Bug 21562 - btrfs is dead slow due to fragmentation
https://bugzilla.kernel.org/show_bug.cgi?id=21562

-- 
Felipe Contreras
