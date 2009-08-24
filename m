From: jim owens <jowens@hp.com>
Subject: Re: [RFC] Early look at btrfs directIO read code
Date: Mon, 24 Aug 2009 13:57:39 -0400
Message-ID: <4A92D493.3070804@hp.com>
References: <4A92853E.8010800@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A92853E.8010800@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Arrrgh...

If I did not already scare you enough to stay away from trying
this code, I already hit another bug. Proving the axiom that
you will find a bad bug as soon as you send your code to anyone.

* non-inline file size must be a multiple of device sector size.

jim
