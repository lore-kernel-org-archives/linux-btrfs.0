From: Peter Stuge <peter@stuge.se>
Subject: Re: minor ID for btrfs-control
Date: Sun, 3 Apr 2011 01:30:16 +0200
Message-ID: <20110402233016.18780.qmail@stuge.se>
References: <Bj4lB4gT1uB@helmut.hullen.de> <4D97A4B0.6010207@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D97A4B0.6010207@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> If you don't want to use udev you have two choices:
> - use devtmpfs
> - create manually a device. But nobody guarantee that the minor/major
> will not  change.

- use a udev replacement intended for embedded systems, such as mdev


//Peter
