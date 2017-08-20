Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:51038 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752848AbdHTMeR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 08:34:17 -0400
Subject: Re: slow btrfs with a single kworker process using 100% CPU
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
 <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
 <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
 <4669553.344.1502874134710.JavaMail.gkos@dynomob>
 <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
 <18522132.418.1502884115575.JavaMail.gkos@dynomob>
 <20170816170003.3f47321d@natsu>
 <31057849.442.1502886546489.JavaMail.gkos@dynomob>
 <a7ecda6e-6b75-c7b9-3546-4f3150de08d3@profihost.ag>
 <27208cbf-0715-970c-5804-fdc7d65193ef@profihost.ag>
 <d6d5e7d6-0d1b-2cb0-70f4-f803d01803bf@profihost.ag>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <f254f6e5-cc98-5025-99dd-02fbeb77e3d3@rqc.ru>
Date: Sun, 20 Aug 2017 15:34:13 +0300
MIME-Version: 1.0
In-Reply-To: <d6d5e7d6-0d1b-2cb0-70f4-f803d01803bf@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm a btrfs user, not a developer; developers can probably provide more 
detailed explanation by looking at stack traces in dmesg etc., but it's 
possible that there's just no quick fix (yet). I presume these are 1413 
_full-volume_ snapshots. Then some operations have to process 
43.65TiB*1413=62PiB of data -- well, metadata for that data, but it's 
still a lot as you may guess, especially if it's all heavily fragmented. 
You can either gradually reduce number of snapshots and wait (it may 
drag for weeks and months), or copy everything to a different device and 
reformat this one, then don't create that many snapshots again.

As for "blocked for more than 120 seconds" messages in dmesg, I see them 
every night after I delete about a dozen of snapshots ~10TiB in _total_ 
volume, albeit with qgroups. These messages usually subside after about 
couple of hours. They only tell you what you already know: some btrfs 
operations are painfully slow.

--

With Best Regards,
Marat Khalili

