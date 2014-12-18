Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:55067 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLRSjo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 13:39:44 -0500
Received: by mail-la0-f54.google.com with SMTP id pv20so1529723lab.13
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 10:39:43 -0800 (PST)
Received: from [10.0.0.163] ([31.99.148.180])
        by mx.google.com with ESMTPSA id or5sm1992625lbb.42.2014.12.18.10.39.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 18 Dec 2014 10:39:42 -0800 (PST)
In-Reply-To: <4A7D957D-FE36-452D-B6DB-12117FF75AB9@gmail.com>
References: <4A7D957D-FE36-452D-B6DB-12117FF75AB9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: btrfs-progs: integration-20141218 possible corruption test regression
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Date: Thu, 18 Dec 2014 18:39:22 +0000
To: linux-btrfs@vger.kernel.org
Message-ID: <719D86DC-BC2F-4A9C-9D17-F90AFFF3FFC2@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 December 2014 18:35:16 GMT+00:00, WorMzy Tykashi <wormzy.tykashi@gmail.com> wrote:
>Hi guys, 
>
>The latest integration fails 'make test' with the following output:
>
>     [TEST]    013-leaf-corruption-no-extent-data.tar.xz
>btrfs check should have detected corruption
>Makefile:144: recipe for target 'test' failed
>make: *** [test] Error 1
>rm btrfs-corrupt-block.o
>
>
>I've only built the progs on a single machine so far, but it
>consistently fails at this test. 
>
>Cheers, 
>
>
>WorMzy

Regression is present in the 3.18.x branch too.

Cheers, 


WorMzy

