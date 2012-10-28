Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47814 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2J1NXw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 09:23:52 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs behave on checksum mismatch?
Date: Sun, 28 Oct 2012 14:23:51 +0100
Cc: Ronnie Collinson <notthinking@gmail.com>,
        Michael =?iso-8859-1?q?Kj=F6rling?= <michael@kjorling.se>
References: <20121027215645.GU2381@yeono.kjorling.se> <20121027220940.GV2381@yeono.kjorling.se> <CAGa+R32R83cAWLQO4Xgwcvp22r1oPkWhmEOMiWB1HUTSb=r18g@mail.gmail.com> (sfid-20121028_141611_461337_7EAD85A8)
In-Reply-To: <CAGa+R32R83cAWLQO4Xgwcvp22r1oPkWhmEOMiWB1HUTSb=r18g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210281423.51427.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Oktober 2012 schrieb Ronnie Collinson:
> In a raid1 situation, it will also rewrite the effected data, on the
> drive that failed the checksum

Will it do so without an explicit scrub?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
