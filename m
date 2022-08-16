Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24E0C2BB41
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Aug 2022 07:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiHPHIO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 03:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiHPHHr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Aug 2022 03:07:47 -0400
Received: from sender4-pp-o92.zoho.com (sender4-pp-o92.zoho.com [136.143.188.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F2A125035
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2022 19:40:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660617611; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=gSNtpW6Aw7qBRmQfU9RXdINj7whgZvMt2qB9jEHKuK8TrKmv15tqSZBK7zb7Hnf0aNKThJNzJtjmQlIVPRuT4J+XJ0T17fHOHNGltPNpPSMY1mpnoETYEQMFXkMyNuFJQxdl3CZutiF1gqkgYKd0RWR3DsQYV+F/rscg1OmxL6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660617611; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mBSvIURNTjtzA7Ykr8BpQOf/HgSlpj5LNwdyH95kCEQ=; 
        b=k4Yfej2CZDsnGrKxcwHANX+hgxYtEmSPH/yn998/vvtbftI9b3gez89ag9X8Hdh//AiOEPK8k6CK0Wtt5/2RTRVLfnwsNdABl3Av9KbX04M6ig256uBpptnrTmo7aNRdIYwPMM/EAlg3nlguYGximJ9Zvh4RGOkbaLUXpyE3KOs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=hmsjwzb@zoho.com;
        dmarc=pass header.from=<hmsjwzb@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=message-id:date:mime-version:user-agent:subject:to:cc:references:from:in-reply-to:content-type; 
  b=uL89VGBZLZokSdkdxMqUPWeCa+hAg/SflaZrNRYMLxtytrZG1/dkHQwtWyjgm4RSA2FZ6QJr53a/
    V7MSOd3POIt1gCXLFkDVcqVDvMdeUOy2E+rvHyCINFybPc1bz3p5  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660617611;
        s=zm2022; d=zoho.com; i=hmsjwzb@zoho.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=mBSvIURNTjtzA7Ykr8BpQOf/HgSlpj5LNwdyH95kCEQ=;
        b=fU1jTJuc29lGDHutWQ+z0WPtVGvK2ip7y9f0Vfkv3NVZKjk7gJNSDizF5FMf/dko
        l824Xuw4+fMs0KULAseJ9xprZgMcPlgx8fuiYvzJw5Tp0A4nYLx1r+Dz/xpjoeAy9JU
        P0DieIaDq8DpbgqUAJAEmMRNvBarzT0D0LHPK1VM=
Received: from [192.168.0.103] (58.247.201.75 [58.247.201.75]) by mx.zohomail.com
        with SMTPS id 1660617608671771.5095035409965; Mon, 15 Aug 2022 19:40:08 -0700 (PDT)
Message-ID: <30296ee6-594c-3964-ca71-4c2fdafa4e05@zoho.com>
Date:   Mon, 15 Aug 2022 22:40:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] btrfs-progs: chunk tree search solution for btrfs249
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org, anand.jain@oracle.com
References: <20220815024341.4677-1-hmsjwzb@zoho.com>
 <65c8f002-eef7-365a-8f1f-53a4d8b216c4@gmx.com>
From:   hmsjwzb <hmsjwzb@zoho.com>
In-Reply-To: <65c8f002-eef7-365a-8f1f-53a4d8b216c4@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

IMO, for btrfs249

mkfs.btrfs -d raid1 -m raid1 /dev/sdb /dev/sdc

btrfstune -S 1 /dev/sdb

wipefs -a /dev/sdb

mount -o degraded /dev/sdc /mnt/scratch

btrfs device add -f /dev/sdd /mnt/scratch

After the above command, the sdb(missing deive) and sdc went to seed_list.
So the missing device will not show by btrfs filesystem usage command.

Fsid of sdb & sdc also changed in above command. Before this command,
btrfs filesystem usage can dump out the device information of sdb & sdc.
After that, only sdd will dump out.

I think this behavior is proper.

Thanks,
Flint

On 8/15/22 04:06, Qu Wenruo wrote:
> This will only load the device info for rw devices.
> 
> But no seed device will be populated, wouldn't this cause problem
> showing missing seed devices?
