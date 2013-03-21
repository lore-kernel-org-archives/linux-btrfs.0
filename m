Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:38980 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3CUI5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 04:57:38 -0400
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= COIFFIER <frederic.coiffier@free.fr>
To: Roman Mamedov <rm@romanrm.ru>
Cc: Chris Murphy <lists@colorremedies.com>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Date: Thu, 21 Mar 2013 09:57:24 +0100
Message-ID: <68196576.8us4kWVCD5@athlonxp>
In-Reply-To: <20130321012414.3b232660@natsu>
References: <6033676.gK0GbPgrpE@athlonxp> <4B672F76-FAF9-4198-988D-440B6326A275@colorremedies.com> <20130321012414.3b232660@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman,

Le jeudi 21 mars 2013 01:24:14 Roman Mamedov a écrit :
> On Wed, 20 Mar 2013 12:19:18 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
> > > 195 Hardware_ECC_Recovered  0x001a   057   055   000    Old_age   Always       -       63508940
> 
> > With such high ECC recovered events, I suspect SDC. 
> 
> If it's a Seagate drive, this is absolutely normal.
> All Seagate drives have a high value in SMART Hardware_ECC_Recovered.

You're right : it's a Seagate :

Model Family:     Seagate Barracuda 7200.10
Device Model:     ST3320620AS

Regards,
Frederic
