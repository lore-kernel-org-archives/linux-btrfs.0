Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:34772 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753744AbeCUWDP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 18:03:15 -0400
Message-ID: <1521669792.4312.43.camel@scientia.net>
Subject: Re: spurious full btrfs corruption
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Wed, 21 Mar 2018 23:03:12 +0100
In-Reply-To: <1521158625.4352.16.camel@scientia.net>
References: <26306A4D-2D8E-4661-B89E-9F050FD184D5@scientia.net>
         <BF03A3DF-684D-47FE-A9AD-320256F64763@scientia.net>
         <b6b4ed0e-9569-158d-19ad-82c885bab4ec@gmx.com>
         <BB977A40-847C-4611-A468-9BF1137CE711@scientia.net>
         <d2a14d69-dfa9-8794-6375-03d1b209632f@gmx.com>
         <68697875-6E77-49C4-B54E-0FADB94700DA@scientia.net>
         <99ee9b31-a38a-d479-5b1d-30e9c942d577@gmx.com>
         <A19E863A-F83C-4630-9675-4309CECB318E@scientia.net>
         <1b24e69e-2c1e-71af-fb1d-9d32f72cc78c@gmx.com>
         <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>
         <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
         <1519833022.3714.122.camel@scientia.net>
         <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
         <1520297878.4428.39.camel@scientia.net>
         <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
         <1520519895.15491.21.camel@scientia.net>
         <1111e6a3-20fd-d3b5-8eaa-672a4a859380@gmx.com>
         <1521158625.4352.16.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just some addition on this:

On Fri, 2018-03-16 at 01:03 +0100, Christoph Anton Mitterer wrote:
> The issue that newer btrfs-progs/kernel don't restore anything at all
> from my corrupted fs:

4.13.3 seems to be already buggy...

4.7.3 works, but interestingly btrfs-find-super seems to hang on it
forever with 100% CPU but apparently no disc IO (works in later
versions, where it finishes in a few seconds).


Cheers,
Chris.
