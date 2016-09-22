Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45073 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1034323AbcIVRz0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:55:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bn8D8-00072O-Ra
        for linux-btrfs@vger.kernel.org; Thu, 22 Sep 2016 19:55:02 +0200
To: linux-btrfs@vger.kernel.org
From: ojab <ojab@ojab.ru>
Subject: Re: Status of free-space-tree feature
Date: Thu, 22 Sep 2016 17:47:59 +0000
Message-ID: <45b54ff1-f226-3994-441c-22003f9dfb95@ojab.ru>
References: <20160921092406.GD16983@twin.jikos.cz>
 <57E2602C.7050703@applied-asynchrony.com>
 <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
 <20160921203152.GA7694@vader.DHCP.thefacebook.com>
 <20160922085205.GM16983@suse.cz>
 <058a4346-16f5-850e-2974-d783a132547b@mendix.com>
 <20160922172651.GB4705@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>, dsterba@suse.cz,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, osandov@fb.com
In-Reply-To: <20160922172651.GB4705@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/09/22 17:26, Omar Sandoval wrote:
 > As far as I know, space_cache=v2 isn't documented in the man page, so
 > hopefully anyone who managed to find out about it follows the mailing
 > list. If someone updates their kernel without updating btrfs-progs, the
 > new compat_ro bit will prevent the old version from doing any damage.

Actually it's documented in `man 5 btrfs`.

//wbr ojab

