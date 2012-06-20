Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58938 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2FTB1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 21:27:32 -0400
Received: by pbbrp8 with SMTP id rp8so10396566pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 18:27:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE10CDF.5050102@zytor.com>
References: <4FDFCA43.2070407@zytor.com>
	<1340115766.3403.19.camel@cwalton-XPS-8300>
	<4FE10CDF.5050102@zytor.com>
Date: Wed, 20 Jun 2012 08:27:31 +0700
Message-ID: <CAG1y0seXhHWVBCax5PK9QkdzSKreZreMdibjJ38LsimgT9zbLg@mail.gmail.com>
Subject: Re: Subvolumes and /proc/self/mountinfo
From: "Fajar A. Nugraha" <list@fajar.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 6:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/19/2012 07:22 AM, Calvin Walton wrote:
>>
>> All subvolumes are accessible from the volume mounted when you use -o
>> subvolid=0. (Note that 0 is not the real ID of the root volume, it's
>> just a shortcut for mounting it.)
>>
>
> Could you clarify this bit?  Specifically, what is the real ID of the
> root volume, then?

5

-- 
Fajar
