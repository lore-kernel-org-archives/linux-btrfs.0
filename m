From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: snapshot limit?
Date: Tue, 17 Aug 2010 11:40:11 -0700
Message-ID: <4C6AD78B.8070503@noir.com>
References: <4C6AC9AC.9000503@noir.com> <AANLkTin1kV1ebL-qOvOOv2e=DZ5qvyWYEEreg-+vqDdP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Dhiru Kholia <dhiru.kholia@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin1kV1ebL-qOvOOv2e=DZ5qvyWYEEreg-+vqDdP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 8/17/10 11:05 , Dhiru Kholia wrote:
> On Tue, Aug 17, 2010 at 10:41 AM, K. Richard Pixley <rich@noir.com
> <mailto:rich@noir.com>> wrote:
>  >  Is there a limit to the number of snapshots that can exist on a file
> system
>  > concurrently?
>
> According to https://help.ubuntu.com/community/btrfs "You can create
> as many subvolumes as you want, as long as you have storage capacity."
>
> --
> Cheers,
> Dhiru
>

Yes.  But if there's a limit to the number of paths that can point to a 
single file, then that's not strictly true.  Rather, there's a limit 
based on the number of snapshots pointing to the same file.

Since a snapshot is a copy of an existing file system, the only time a 
snapshot would not have files in common with previous snapshots would be 
in snapshots of empty file systems.  Making snapshots of empty file 
systems begs the question of why one would be bothering with snapshots 
anyway.

Hence, I suspect that in the vast majority of practical cases, there is 
indeed a current limit to the number of snapshots that can be made 
concurrently based on the limit to the number of paths to a single file. 
  I was looking for validation of this theory and perhaps a way to 
detect, avoid, and/or recover from this situation.

I'm experiencing at least one recurring error condition resulting in a 
polluted file system.  I'm using a lot of snapshots in this particular 
application.  So I'm wondering if such a limit exists and/or how to 
determine if I am running into this situation.

Can anyone offer any clarification?

--rich
