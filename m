From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: raid 1 / raid 10
Date: Thu, 16 Oct 2008 14:48:22 +0100
Message-ID: <f058a9c30810160648w7e1ff718o582a1c2af2a16b77@mail.gmail.com>
References: <1df9a2bf0810160112wff9e874x1f949dd704fa1480@mail.gmail.com>
	 <1224163942.7300.0.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: rektide <rektide@gmail.com>, linux-btrfs@vger.kernel.org
To: "Eric Anopolsky" <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224163942.7300.0.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2008 at 2:32 PM, Eric Anopolsky <erpo41@gmail.com> wrote:
> On Thu, 2008-10-16 at 04:12 -0400, rektide wrote:
>> Is there any case where the third and fourth disks would be
>> used with -m raid1 -d raid1?
>
> Perhaps when the first pair of disks fill up? I don't know. I'm new
> here.

I didn't check the code, that would be kind of a "linear append"..
which is dump....
I was expecting a raid1 with 4 discs, to have exactly 3 copies of the
original data, with each disk being a complete mirror.

If we only have 1 copy (plus original), and therefore use only 2 disks
for any individual write, probably, if we generate enough write load
to make a couple of disks busy, it will use the second couple of disks
also.
Basically, the allocator should be able to balance the write load, and
spread allocations to all devices.. however.. if the write load is
insuficient to saturate a single pair of devices, there's no point in
using the second pair.. it would just make the machine burn more watts
This is pure speculation...

Best thing is to look at the code. :)

Kind regards,

-- 
Miguel Sousa Filipe
