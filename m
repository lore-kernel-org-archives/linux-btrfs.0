Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36895 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2ITVDo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 17:03:44 -0400
Received: by pbbrr4 with SMTP id rr4so1038887pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 14:03:44 -0700 (PDT)
Message-ID: <505B84AD.7010808@gmail.com>
Date: Fri, 21 Sep 2012 05:03:41 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, dave@jikos.cz
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: enquiry about autodefrag option
References: <50570652.4060200@gmail.com> <5059AC5E.1030003@gmail.com> <5059D2D3.3050303@oracle.com> <505A5715.9060309@gmail.com> <20120920115111.GJ17430@twin.jikos.cz>
In-Reply-To: <20120920115111.GJ17430@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> Is there any io niceness control for autodefrag process too? it will
>> be nice if the idle class is used.
> No. Autodefrag will mark file data dirty and they'll be written back to
> the storage in the same way as any other write through the worker
> threads.
>
>

AFAIK, the autodefrag will read related extents and mark them dirty, io niceness should be applicable to the read operation
