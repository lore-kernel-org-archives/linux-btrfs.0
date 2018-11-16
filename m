Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D087C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 09:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE0F22089D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 09:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nd2iHrHK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE0F22089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbeKPToP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:44:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbeKPToP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 14:44:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAG9UEdj192364;
        Fri, 16 Nov 2018 09:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=CcDNdYPpJEyIia3PB/GOoLBy8GHsR13x1YDJKv9oeKs=;
 b=Nd2iHrHKzZjhKKZjpcWwkUFc7BqrG9QiKswpr8CL5JMWm+74d7kM92TOYUUcBAYfjmly
 mDTUW93CGHz/GS+eicW9SzQHjIma6WqNBGSVoyRo/96od8Rqn0Xn/oy0TfPT9FEVdw6k
 RCg434mrNGpcxarsAve26o86/AXNfVDYagPnVFO0apZnd9V/BoISlz+gPHeNw3TUE9NK
 SwWma1Ul8Susyflmcs3BNwwd4LKQPsjO3m7gxrAfdtVaFPmOM/WDyDpY91zrYcZr7fT+
 kIrulasMj3pi7iC04Nv3T6HOmxkNMrWd1KguAYdZIiuOJlFLXX9mkdEumYDT/h77AywH qQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nr7cse43y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 09:32:41 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAG9WeTp010189
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 09:32:40 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAG9WeKG025281;
        Fri, 16 Nov 2018 09:32:40 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 01:32:40 -0800
Subject: Re: [PATCH 0/9 v2] fix replace-start and replace-cancel racing
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <20181115154136.GV24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1e7e50d8-72df-f9b9-2cad-78e026e6a1c0@oracle.com>
Date:   Fri, 16 Nov 2018 17:32:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181115154136.GV24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9078 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160087
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/15/2018 11:41 PM, David Sterba wrote:
> On Sun, Nov 11, 2018 at 10:22:15PM +0800, Anand Jain wrote:
>> v1->v2:
>>    2/9: Drop writeback required
>>    3/9: Drop writeback required
>>    7/9: Use the condition within the WARN_ON()
>>    6/9: Use the condition within the ASSERT()
>>
>> Replace-start and replace-cancel threads can race to create a messy
>> situation leading to UAF. We use the scrub code to write
>> the blocks on the replace target. So if we haven't have set the
>> replace-scrub-running yet, without this patch we just ignore the error
>> and free the target device. When this happens the system panics with
>> UAF error.
>>
>> Its nice to see that btrfs_dev_replace_finishing() already handles
>> the ECANCELED (replace canceled) situation, but for an unknown reason
>> we aren't using it to cleanup the replace cancel situation, instead
>> we just let the replace cancel ioctl thread to cleanup the target
>> device and return and out of synchronous with the scrub code.
>>
>> This patch 4/9, 5/9 and 6/9 uses the return code of btrfs_scrub_cancel()
>> to check if the scrub was really running. And if its not then shall
>> return an error to the user (replace not started error) so that user
>> can retry replace cancel. And uses btrfs_dev_replace_finishing() code
>> to cleanup after successful cancel of the replace scrub.
>>
>> Further, a suspended replace, when tries to restart, and if it fails
>> (for example target device missing, or excl ops running) it goes to the
>> started state, and so the cli 'btrfs replace status /mnt' hangs with no
>> progress. So patches 2/9 and 3/9 fixes that.
>>
>> As the originals code idea of ECANCELED was limited to the situation of
>> the error only and not user requested, there are unnecessary error log
>> and warn log which 7/9 and 8/9 patches fixes.
>>
>> Patches 1/9 and 9/9 are good to have fixes. Makes a function static and
>> code readability good.
>>
>> Testing: (I did some attempt to convert these into xfstests but need a
>> mechanism where kernel thread can wait for user land script. I thought
>> I could do it using ebfp, but needs more digging on how).
>> As of now hand tested with using procfs to hold kernel thread at
>> (wait_for_user(..)) until user land issues go.
> 
> This could be tricky to get implemented but would be of course useful. I
> saw the crash about once a week so will watch if this still happens.

  That will be nice.

>> Anand Jain (9):
>>    btrfs: mark btrfs_dev_replace_start() as static
>>    btrfs: replace go back to suspended if target missing
>>    btrfs: replace back to suspend state if EXCL OP is running
>>    btrfs: fix UAF due to race between replace start and cancel
>>    btrfs: replace cancel is successful if scrub cancel is successful
>>    btrfs: replace's scrub must not be running in replace suspended state
>>    btrfs: quiten warn if the replace is canceled at finish
>>    btrfs: user requsted replace cancel is not an error
>>    btrfs: add explicit check for replace result no error
> 
> The above is merged to misc-next, except:
> 
> btrfs: quiten warn if the replace is canceled at finish
> btrfs: user requsted replace cancel is not an error
> 
> with replies under the patches what could be improved. The changes can
> be sent independently if you need to do that in several patches. Thanks.

  We need these patch otherwise you will see WARN_ON and btrfs_err
  after a successful replace cancel. Will send revised patch.

Thanks, Anand
