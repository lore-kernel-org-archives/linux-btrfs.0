Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F825C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 12:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D632920870
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 12:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kj2d7o6U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D632920870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbeLMMsp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:48:45 -0500
Received: from mail-it1-f182.google.com ([209.85.166.182]:36068 "EHLO
        mail-it1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728517AbeLMMsp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 07:48:45 -0500
Received: by mail-it1-f182.google.com with SMTP id c9so3614674itj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 04:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UMjzYgQRM2dLGri6pg+MwNexi/vnQGJOlOa5htZsE44=;
        b=Kj2d7o6Ud03aVXkRDQ0yGrIc7IDEgc2Ov9AAWLuG2pywjflphiB6bLorHm1CKrj1EY
         /zLDVfdtycXl8tGCY619mWWB5YcffEbthku+ZsrCO1LlCsLb7Q9kpcF1Tl9oCMLY3FX2
         B2Mh/zzYqV8MmwMc+ajr9yzp+u6BiioM+gi8pnjHfDGF15i+fOWhYmoxBYAjTwLbpRWX
         lC6KbAID0mWPqaWYhCB2cTbl2Juk1ky/czS0jC/54iNKWm/mGikKMA7JPzXaai3oz/pv
         cfxayBY2f8nBeVbjr+gh5cxyVrOwqT7cWzveHT7pZAMJRWjBNGBmg+xhjw8AspBCHlj+
         +x5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UMjzYgQRM2dLGri6pg+MwNexi/vnQGJOlOa5htZsE44=;
        b=g2/OHiw8+5DaDIu0faNmQtYI+vSpKdzmV2OvNC1O2ZnS+EQ0kVSSrBhCjmv6eMd75u
         dnFGXKacnt6W2PdtqmHLIUSjeFD5E6KBt60Y25Q0MmF337clh+w3dl3T5ApKO6JXQf7N
         pd6+rN0pj4Mf5Ef5w9yI1FnTuJKGNxbOK5qKIlyCyr4tCfjSVvccJpVJuHA+cSM0qroY
         xt/Bqg7B/f+2OHaA48lSjO/Ng4TmQMsplzLjnlg9Ery5wrWSA7r8+oUtqjPt1f6X3cXa
         vq3ip4nn/JbXv9Vobad+hGKPKg6Xk+LzHdISwfMr865+IVZS2aaEaV3PcuA28o0hTECM
         osjQ==
X-Gm-Message-State: AA+aEWbtVR3tot00zUFYm5fAq+zc9HMfFaYfzl8a/vv+aRRmCs4sp2CG
        ynPNwOw3TOqtwUmWqKwj1FKgFAZMYGzwhA==
X-Google-Smtp-Source: AFSGD/W9dBB2W6e2UpnoJLs0AvAvUE6t85SsLdzPA5SnDKhOsy2PNkf5C9ghU3XzafArE30Myljeug==
X-Received: by 2002:a02:4d46:: with SMTP id l67mr23290853jab.141.1544705323431;
        Thu, 13 Dec 2018 04:48:43 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id t2sm693442iob.7.2018.12.13.04.48.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 04:48:42 -0800 (PST)
Subject: Re: SATA/SAS mixed pool
To:     Remi Gauvin <remi@georgianit.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Nathan Dehnel <ncdehnel@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
 <20181213072905.ac352nclowixfhpt@angband.pl>
 <60315740-e3e5-ed7f-a25b-6889932d0cfd@georgianit.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b55eaa23-ebda-c7c1-e56c-cab0cf859456@gmail.com>
Date:   Thu, 13 Dec 2018 07:48:40 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <60315740-e3e5-ed7f-a25b-6889932d0cfd@georgianit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-13 05:39, Remi Gauvin wrote:
> On 2018-12-13 02:29 AM, Adam Borowski wrote:
> 
>>
>> For btrfs, a block device is a block device, it's not "racist".
>> You can freely mix and/or replace.  If you want to, say, extend a SD
>> card with NBD to remote spinning rust, it works well -- tested :p
>>
> 
> The possibility ff NBD certainly intrigues me, but I would be concerned
> about the write barriers,, (needed to make sure cached writes are
> committed to spinning rust in the correct order, so as to avoid
> corruption in the case of interruption.
> 
> Assuming the underlaying block device on the remote device has a working
> implementation, (as we know, not always a safe assumption...) does NBD
> properly pass along the barriers commands/support?
I don't think there's any auto-detection, but newer versions of the NBD 
server software provide two options in the export configuration, 
`flush`, and `fua`, which will let you enable support for those two 
commands, though they only get used if the client supports them. 
Unless I'm mistaken, they both need support from the block device being 
exported if it's actually a block device, though they do not if it's a 
regular file (`flush` translates to `fdatasync()` or `fsync()`, while 
`fua` translates to `sync_file_range()`).
