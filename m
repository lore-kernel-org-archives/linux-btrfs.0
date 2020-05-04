Return-Path: <SRS0=eotd=6S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7315C3A5A9
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 May 2020 21:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C8E20663
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 May 2020 21:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEDVnm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 May 2020 17:43:42 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:52260 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgEDVnm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2020 17:43:42 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2020 17:43:41 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id A4BA86071A61;
        Mon,  4 May 2020 23:37:51 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Q4C373pAJ6rz; Mon,  4 May 2020 23:37:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 4F0D56071A7C;
        Mon,  4 May 2020 23:37:51 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 423_N2Ped0W1; Mon,  4 May 2020 23:37:51 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 299566071A61;
        Mon,  4 May 2020 23:37:51 +0200 (CEST)
Date:   Mon, 4 May 2020 23:37:51 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        david <david@sigma-star.at>,
        Sascha Hauer <s.hauer@pengutronix.de>
Message-ID: <769963893.184242.1588628271082.JavaMail.zimbra@nod.at>
In-Reply-To: <SN4PR0401MB3598198E5FB728B68B39A1589BA60@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200428105859.4719-1-jth@kernel.org> <20200428105859.4719-2-jth@kernel.org> <20200501053908.GC1003@sol.localdomain> <SN4PR0401MB3598198E5FB728B68B39A1589BA60@SN4PR0401MB3598.namprd04.prod.outlook.com>
Subject: Re: [PATCH v2 1/2] btrfs: add authentication support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: btrfs: add authentication support
Thread-Index: AQHWHUw3Fjk34p8J2kWvUrIfOj4Hzdzgc2Od
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

----- Ursprüngliche Mail -----
>> The hash algorithm needs to be passed as a mount option.  Otherwise the attacker
>> gets to choose it for you among all the supported keyed hash algorithms, as soon
>> as support for a second one is added.  Maybe use 'auth_hash_name' like UBIFS
>> does?
> 
> Can you elaborate a bit more on that? As far as I know, UBIFS doesn't
> save the 'auth_hash_name' on disk, whereas 'BTRFS_CSUM_TYPE_HMAC_SHA256'
> is part of the on-disk format. As soon as we add a 2nd keyed hash, say
> BTRFS_CSUM_TYPE_BLAKE2B_KEYED, this will be in the superblock as well,
> as struct btrfs_super_block::csum_type.

Well, UBIFS stores auth_hash_name on disk but does not trust it.
It is always required to provide auth_hash_name as mount parameter.
At mount time it is compared to the stored name (among with other parameters)
to detect misconfigurations.

Thanks,
//richard

