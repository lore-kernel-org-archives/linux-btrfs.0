Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3DSSNV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 14:13:21 -0400
Message-ID: <51718941.2010800@redhat.com>
Date: Fri, 19 Apr 2013 11:13:21 -0700
From: Andy Grover <agrover@redhat.com>
MIME-Version: 1.0
To: Suman C <schakrava@gmail.com>
CC: Roman Mamedov <rm@romanrm.ru>, "Fajar A. Nugraha" <list@fajar.net>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: lvm volume like support
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com> <20130226115704.50102196@natsu> <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com>
In-Reply-To: <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2013 10:25 PM, Suman C wrote:
> Thanks for the sparse file idea, I am actually using that solution
> already. I am not sure if its the best way, however.

(Sorry to respond to such an old thread.)

Hi Suman,

I think zvol-like functionality would be very nice for btrfs to have. It 
would be more natural to manage btrvols than looped-back files I think, 
and removing those sw layers may also increase performance, but who 
knows by how much. It would let btrfs really act as "just" the LVM, if 
desired.

Do we have any sense for how much work adding this would be?

Regards -- Andy

p.s. some interesting stuff on zvols 
http://pthree.org/2012/12/21/zfs-administration-part-xiv-zvols/

