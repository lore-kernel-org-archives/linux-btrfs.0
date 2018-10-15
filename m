Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3190C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F4B2089D
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDEuTfBx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64F4B2089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbeJOWsO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 18:48:14 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:44871 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeJOWsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 18:48:14 -0400
Received: by mail-io1-f41.google.com with SMTP id s6-v6so3862261ioa.11
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 08:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WbMHViU5jESX5sWEBmyuQEw06hMHFauSoi8tKbmzRlw=;
        b=NDEuTfBxfzDLEFNnj+/fBGjeRWR7YOgEvUq5cFFM8LMmy8oCaeeXo2evoJDQmeZxdC
         486oVIlhu9FzptV2CqqdEouWbFm3pKlHuEUcXL9qGsdtX9Nku5unyMatKzf28FdlQaT9
         pn7ovl55W4ZhLS3l/io0ZC0S0PNAz3413cWfr/9qXbt9cYhCDlQZMTdrSJYrHTzRocqn
         Ww+vFy6/IjQrHWUgmlQ50/D9GgacfMy7nd+cdr8qMa4LY/z4X9TPVc3ljex5G0U+iRCs
         fBQTcgowZkA78a2YGArKwLfWQ2gpiVmTSyiMQNOWFgsdPDhj2cjbUgCWuzchJtrmNUFv
         jJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WbMHViU5jESX5sWEBmyuQEw06hMHFauSoi8tKbmzRlw=;
        b=cBlMV1i8Mx1B5wI7DYHm/IUUVJ9ucKtCigPJFwX9f+oY2eEgmOVPgwkyRBKh17FCqm
         EDdOSID0/IzjjBwbawiGV1nRrwLFyUIbZ6YGsOsXJHz+j8PYfP7osb5FmfgkV6AuuCFT
         /RLLMUK66g+J0EA+h7Ht981iFJDaU/c6507+qG12U9c5mKTah6nm2o8p5szWkyWKDNhR
         UG6DB1xYVmGx2L9zSbTRispi4mIR0zXxBqdOxLrNRKH1NUp+MeviEbPye1RdzwWxKE0E
         Xb+VIyJhKqoKuCyN0X2Fn8uKo57lwPORSp6OPLfxoP2aVDa3AZAfiecsIhepneeFLsHN
         Cu6Q==
X-Gm-Message-State: ABuFfohU59M8NCU5qmvKFxZtXwVi6BbZGSlyI+IqeBX6BDt0aN5vQeoh
        FSBs1L/FYdhJ1ri74x8g1o6BpUqiUepjXQ==
X-Google-Smtp-Source: ACcGV627ODDic032wn2xxUadvYVwyOpwdBf+zlVbJpFTPEI+e0S7cOoIQbJoqYa8fKbkcKLcaTyyCg==
X-Received: by 2002:a6b:6e0b:: with SMTP id d11-v6mr10309711ioh.4.1539615755245;
        Mon, 15 Oct 2018 08:02:35 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i71-v6sm4320329iti.15.2018.10.15.08.02.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 08:02:33 -0700 (PDT)
Subject: Re: Interpreting `btrfs filesystem show'
To:     Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181015172408.1b3867debea3951fb7014ee4@gmail.com>
 <20181015142641.GD9538@carfax.org.uk>
 <20181015174040.6f4962336386d8549026908c@gmail.com>
 <20181015174238.cb240bc0df3efffb92cec42a@gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6f37f89d-105e-1abe-980a-3c0662c98c4f@gmail.com>
Date:   Mon, 15 Oct 2018 11:02:31 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181015174238.cb240bc0df3efffb92cec42a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-15 10:42, Anton Shepelev wrote:
> Hugo Mills to Anton Shepelev:
> 
>>> While trying to resolve free space problems, and found
>>> that I cannot interpret the output of:
>>>
>>>> btrfs filesystem show
>>>
>>> Label: none  uuid: 8971ce5b-71d9-4e46-ab25-ca37485784c8
>>>         Total devices 1 FS bytes used 34.06GiB
>>>         devid    1 size 40.00GiB used 37.82GiB path /dev/sda2
>>>
>>> How come the total used value is less than the value
>>> listed for the only device?
>>
>>    "Used" on the device is the mount of space allocated.
>> "Used" on the FS is the total amount of actual data and
>> metadata in that allocation.
>>
>>    You will also need to look at the output of "btrfs fi
>> df" to see the breakdown of the 37.82 GiB into data,
>> metadata and currently unused.
>>
>> See
>> https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools for the details
> 
> Thank you, Hugo, understood.  mount/amount is a very fitting
> typo :-)
> 
> Does the standard `du' tool work correctly for btfrfs?
> 
For the default 'physical usage' mode, it functionally does not work 
correctly, because it does not know about reflinks.  The easiest way to 
see this is to create a couple of snapshots of a subvolume alongside the 
subvolume, and then run `du -s --totals` on those snapshots and the 
subvolume.  It will report the total space usage to be equal to the sum 
of the values reported for each snapshot and the subvolume, when it 
should instead only count the space usage for shared data once.

For the 'apparent usage' mode provided by the GNU implementation, it 
does work correctly.
