Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40994 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2L0WKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 17:10:18 -0500
Message-ID: <50DCC747.2030609@petaramesh.org>
Date: Thu, 27 Dec 2012 23:10:15 +0100
From: =?windows-1252?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Another novice question & comment
References: <50DC5B51.9060506@czarc.net> <20121227150328.GV19051@carfax.org.uk> <50DC7BA0.2080401@petaramesh.org> <95393023-B40D-4331-A429-3D488B9D0576@colorremedies.com> <50DC7F85.4020807@petaramesh.org> <FFF59EFE-0915-4DDF-88AD-1C927F28A4E6@colorremedies.com> <50DCA13F.9080805@petaramesh.org> <36B90EDC-69A7-457A-AAE6-2EE81B30190B@colorremedies.com>
In-Reply-To: <36B90EDC-69A7-457A-AAE6-2EE81B30190B@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 27/12/2012 20:35, Chris Murphy a écrit :
> On Dec 27, 2012, at 12:27 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
>
>> Le 27/12/2012 20:25, Chris Murphy a écrit :
>>> For whatever reason, our mount command behaviors differ. When I use mount, I do not get a subvol entry at all in parenthesis like you are. I can only see this information in /proc/self/mountinfo.
>> I get this on vanilla Ubuntu 12.10 Quantal…
> I have util-linux 2.22.1 and libmount 2.22.0, what about you?
>
>

# dpkg -s util-linux
Package: util-linux
[...]
Architecture: amd64
Multi-Arch: foreign
Version: 2.20.1-5.1ubuntu2

# dpkg -s libmount1
Package: libmount1
[...]
Architecture: amd64
Multi-Arch: same
Source: util-linux
Version: 2.20.1-5.1ubuntu2

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

