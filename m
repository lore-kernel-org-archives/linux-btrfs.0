From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: kernel bug
Date: Sat, 24 Sep 2011 21:45:27 +0200
Message-ID: <CABVOS0-UTUv3uFRFtQw++emWOBxSZXJ3QnUjq43jPmXeGm=tYg@mail.gmail.com>
References: <CABVOS0-ELuCKZ5PGvMuZ=RO+V81LPPKXTwDPVEBGtZ=sWKOWvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABVOS0-ELuCKZ5PGvMuZ=RO+V81LPPKXTwDPVEBGtZ=sWKOWvw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I forgot to mention that every process writing to btrfs partition
hanged and cannot be killed by 'kill -9', btrfs filesystem cannot be
unmounted.
