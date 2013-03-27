Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:40543 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab3C0GSx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 02:18:53 -0400
Message-ID: <51528F4B.3030703@jan-o-sch.net>
Date: Wed, 27 Mar 2013 07:18:51 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Koen De Wit <koen.de.wit@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: The -c option of btrfs qgroup limit
References: <5152311B.40908@oracle.com>
In-Reply-To: <5152311B.40908@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Koen,

On 27.03.2013 00:36, Koen De Wit wrote:
> The "btrfs qgroup limit" command has an option -c which means "limit amount
> of data after compression". Whether this option is specified or not, I seem
> to be able to write more well-compressible data than the specified limit. I
> was expecting that omitting the -c option would never allow me to write
> more data than specified by the limit. Am I missing something? Which
> difference in behavior should I expect from the -c option?

Today: none. In the future: The one you describe. That option is planned
but not implemented. We should have mentioned that in the qgroup usage,
I agree.

-Jan
