Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25146 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3CGONq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 09:13:46 -0500
Message-ID: <5138A08B.6000607@oracle.com>
Date: Thu, 07 Mar 2013 22:13:31 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org>
In-Reply-To: <513883DD.8080203@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 03/07/2013 08:11 PM, Swâmi Petaramesh wrote:
> Hi,
>
> mkfs.btrfs v0.20-rc1, as provided in the excellent "Parted Magic" tool,
> latest version dated 2013/02/28, is broken :
>
> When trying to mkfs.btrfs - even on newly made, FS-free partition, it
> always spits an error that it cannot check partition mount status and fails.

  Can you share the command and error-output. Unless I know the actual
  error any suggestion/comments will just be a guess-work.

> There has always been such an issue with mkfs.btrfs AFAIR, but it can
> more or less work depending on the distribution etc...

  Yes. Most of these were printed as error without an impact.
  to have confirmation its better if you could share the
  command and its error-output.

regds, Anand

> In the past, some versions of mkfs.btrfs had a "-f" option that would
> force formatting even if this test failed, but alas this option seems to
> have disappeared...
>
> PartedMagic being a "live CD", it might be easy to reproduce and check
> what, exactly, goes wrong ?
>
> Kind regards.
