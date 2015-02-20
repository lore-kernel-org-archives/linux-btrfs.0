Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60340 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062AbbBTVWQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 16:22:16 -0500
Message-ID: <54E7A580.6010902@fb.com>
Date: Fri, 20 Feb 2015 16:22:08 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs: ENOMEM bugfixes
References: <cover.1424168589.git.osandov@osandov.com> <20150220212007.GA27049@mew.dhcp4.washington.edu>
In-Reply-To: <20150220212007.GA27049@mew.dhcp4.washington.edu>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2015 04:20 PM, Omar Sandoval wrote:
> On Tue, Feb 17, 2015 at 02:51:06AM -0800, Omar Sandoval wrote:
>> Hi,
>>
>> As it turns out, running with low memory is a really easy way to shake
>> out undesirable behavior in Btrfs. This can be especially bad when
>> considering that a memory limit is really easy to hit in a container
>> (e.g., by using cgroup memory.limit_in_bytes). Here's a simple script
>> that can hit several problems:
>>
>> ----
>> #!/bin/sh
>>
>> cgcreate -g memory:enomem
>> MEM=$((64 * 1024 * 1024))
>> echo $MEM > /sys/fs/cgroup/memory/enomem/memory.limit_in_bytes
>>
>> cgexec -g memory:enomem ~/xfstests/ltp/fsstress -p128 -n999999999 -d /mnt/test &
>> trap "killall fsstress; exit 0" SIGINT SIGTERM
>>
>> while true; do
>> 	cgexec -g memory:enomem python -c '
>> l = []
>> while True:
>> 	l.append(0)'
>> done
>> ----
>>
>> Ignoring for now the cases that drop the filesystem into read-only mode
>> with relatively little fuss, here are a few patches that fix some of the
>> low-hanging fruit. They apply to Linus' tree as of today.
>>
> So I didn't realize this until I saw Tetsuo Handa's email to the ext4
> list (https://urldefense.proofpoint.com/v1/url?u=http://thread.gmane.org/gmane.comp.file-systems.ext4/47855&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=nzG8bjaiVMyWylHxOvTeXimzfSNyukj4%2BAxs0AZ%2FxOI%3D%0A&s=cbd7d48f1866e79f75b88b7f94a394c53d34adfcc1a30a842382f653c978e180), but
> it looks like this behavior was exposed by a change to the kernel memory
> allocator related to the too-small-to-fail allocation fiasco. To
> summarize, Commit 9879de7373fc (mm: page_alloc: embed OOM killing
> naturally into allocation slowpath), merged for v3.19-rc7, changed the
> behavior of GFP_NOFS allocations which makes it much easier to trigger
> allocation failures in filesystems.
>
> This means that Btrfs falls over under memory pressure pretty easily
> now, so it might be a good idea to follow the conversation over at
> linux-mm (https://urldefense.proofpoint.com/v1/url?u=http://thread.gmane.org/gmane.linux.kernel.mm/126398&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=nzG8bjaiVMyWylHxOvTeXimzfSNyukj4%2BAxs0AZ%2FxOI%3D%0A&s=5177c5ceb03f82d8abb0beeeb4dc5e0c45cc77e9687881590e3ef1701f069a85).
>
> These are bugs regardless of the outcome there, however, so I'd like to
> see this patch series merged.
>

Yeah I'm fine with this, your stuff fixes actual problems and they look 
sane so I'm cool with taking them.  Regardless of what the mm guys do we 
shouldn't fall over horribly when allocations fail.  Thanks,

Josef
