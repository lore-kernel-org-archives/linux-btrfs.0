Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F7CC07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 18:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD5720823
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 18:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfARS45 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 13:56:57 -0500
Received: from mx0a-00296801.pphosted.com ([148.163.150.38]:40208 "EHLO
        mx0a-00296801.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728989AbfARS45 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 13:56:57 -0500
X-Greylist: delayed 1829 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2019 13:56:56 EST
Received: from pps.filterd (m0114583.ppops.net [127.0.0.1])
        by mx0a-00296801.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x0IILBSc031198
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 18:26:27 GMT
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        by mx0a-00296801.pphosted.com with ESMTP id 2pyc5gxbj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 18:26:27 +0000
Received: by mail-wr1-f69.google.com with SMTP id l1so7166078wrn.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 10:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PrRCetSOCuh0A5JNgwDFchh9xTM0fv2cbF1Y7SvM1GA=;
        b=euTI4of+qN4LgS/2hjLBaEIt3Wh8tYA3IOUOjH9PY+RmyQ03opG3ws+BOwSMSOHIpK
         WvE88fZGFYybSy3mS+PYfj2SUsomsi8VzXOa8WCkx1IK024S35ObFTwnzf4AYzTBunWg
         TAH/StHUh7d0YnkaPKULCkJTZE0gTzl3b4O5G7eaqe+kQTos/fBgBe9Aj0Xenl2WSedh
         aq3BlcEm5oImePlzESe7cFBqqw3F2o7Slygs1M/vOOWkAAlFoTimAron2VgUMh57Fn99
         d5qtHzHbX6bSZ46SuZaycgMQg0wKdbD3laXuq7NLNIFL53LNsDNI2xHIDHkzmQCtVjsi
         3esw==
X-Gm-Message-State: AJcUukd5URc4HxvkZerMFatHhnyJg1ODAlDpEYkxltHC7eJJAQbEOQxB
        j6kjwxFBfIXznCE2VgPgbho1YmUISkDUdxwBCrcqh5qp3WdvjzkQ3q6IM7+qrh7JaBvqxBf490B
        2bYgibCeGOsRXMj3mejtj4npXRr22av2t/qLLPGiZSE1zEU2/I90xuXIKIRRxUIh3
X-Received: by 2002:adf:ba05:: with SMTP id o5mr17031261wrg.325.1547835984788;
        Fri, 18 Jan 2019 10:26:24 -0800 (PST)
X-Google-Smtp-Source: ALg8bN7EqLyV32F7ychLvm08yYRrhBVRRXOOSG++wNxUONVGkg58gn16CXreb7HJSqFmPdh8yP8B0mHwl0o//rPrzMM=
X-Received: by 2002:adf:ba05:: with SMTP id o5mr17031248wrg.325.1547835984454;
 Fri, 18 Jan 2019 10:26:24 -0800 (PST)
MIME-Version: 1.0
From:   Krishna Mannem <kmannem@pivotal.io>
Date:   Fri, 18 Jan 2019 13:26:13 -0500
Message-ID: <CA+VXTjgtyrWvpNd+5N_pz95s34LcwWLsUyVR-ioj28r81mHf_Q@mail.gmail.com>
Subject: trouble with btrfs lockup
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-18_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=862 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901180132
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I work on Concourse-CI (https://concourse-ci.org/). It's a container
based CI system where we create volumes using Btrfs. Due to the nature
of Concourse, btrfs subvolumes are short lived ( sometimes a few
seconds if it's a small automation task, sometimes hours if its a long
build and test suite). We ran into a failure and we're not really sure
what to make of it. Looks like a lock failed to get acquired before
scheduling? We need another eye on this.

>uname -a
Linux a06d0ae3-b242-4518-85ba-977426a3f214 4.15.0-43-generic
#46~16.04.1-Ubuntu SMP Fri Dec 7 13:31:08 UTC 2018 x86_64 x86_64
x86_64 GNU/Linux

> btrfs df
btrfs filesystem df /var/vcap/data/baggageclaim/volumes
Data, single: total=263.01GiB, used=262.59GiB
System, DUP: total=8.00MiB, used=48.00KiB
Metadata, DUP: total=9.00GiB, used=6.60GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Calltrace:
https://gist.github.com/kcmannem/3baf848845bc986f5ac7d23d3df51e56
