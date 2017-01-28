Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 162-144-52-249.unifiedlayer.com ([162.144.52.249]:47268 "EHLO
        cl65.servermonkeys.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdA1IDo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 03:03:44 -0500
Received: from [64.237.37.122] (port=23142 helo=[10.1.10.10])
        by cl65.servermonkeys.com with esmtpa (Exim 4.87)
        (envelope-from <rich@richgannon.net>)
        id 1cXO93-0004z9-1k
        for linux-btrfs@vger.kernel.org; Sat, 28 Jan 2017 08:14:01 +0000
To: linux-btrfs@vger.kernel.org
From: Rich Gannon <rich@richgannon.net>
Subject: Questions about drive sector sizes
Message-ID: <36efd437-2b6a-0ee8-7aba-c4892d892d82@richgannon.net>
Date: Sat, 28 Jan 2017 03:03:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Btrfs users and devs,


I've gone searching through the mailing list dating back to 2014 or so 
and never found a positive answer - mostly "guesses" about as to the 
answer, albeit with good theories.  I have two separate questions I'm 
looking to have answered with the latest known facts, benchmarks, and 
anecdotes.


1. If a "raw" drive (no partitions) is formatted with Btrfs, will it 
correctly be aligned to 512 or 4k sectors with no additional flags?


2. If question 1's answer is true, will drives of varying sector sizes 
(512 and 4k) in the same array still be aligned correctly in single, 
raid0, raid1, raid5, etc. modes?


Thanks for your input,

Rich

