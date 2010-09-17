From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: btrfs on LVM: Out of space
Date: Fri, 17 Sep 2010 17:29:03 +0200
Message-ID: <201009171729.03854.johannes.hirte@fem.tu-ilmenau.de>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com> <AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com> <AANLkTinNr4-6ONKiHehRKZVTZfa47jAby-X0NR3mGroj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Marcel Lohmann <marcel.lohmann@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinNr4-6ONKiHehRKZVTZfa47jAby-X0NR3mGroj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 10 September 2010 21:46:49 Marcel Lohmann wrote:
> Trying to use "-l 2048" during mkfs was rejected as being invalid. But
> who cares...?
> 
> Marcel

That's because btrfs supports only leafsize equal to pagesize for now.

regards,
  Johannes
