From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Fri, 10 Jun 2011 10:06:49 +0800
Message-ID: <BANLkTi=-xRoNBQHT+qS9eA_vHQnYOBGGjQ@mail.gmail.com>
References: <201106061220.05696.markotahal@gmail.com>
	<4DF179ED.1080001@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marek Otahal <markotahal@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Andy Lutomirski <luto@mit.edu>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF179ED.1080001@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On 10 June 2011 09:57, Andy Lutomirski <luto@mit.edu> wrote:
> On 06/06/2011 06:19 AM, Marek Otahal wrote:
>>
>> Hello,
>> the issue happens every time when i have to hard power-off my notebo=
ok
>> (suspend problems).
>> With kernel 2.6.39 the partition is unmountable, solution is to boot
>> 2.6.38 kernel which
>> 1/ is able to mount the partition,
>> 2/ by doing that fixes the problem so later .39 (after clean shutdow=
n) can
>> mount it also.
>
> Same problem here. =A0Mounting with 2.6.38 says:
>
> [ =A0 41.906259] Btrfs loaded
> [ =A0 41.906747] device fsid e040a9d60da49596-66c0275e348878bf devid =
1 transid
> 69217 /dev/mapper/vg_midnight_ssd-home
> [ =A0 41.908767] btrfs: disk space caching is enabled
> [ =A0 42.232185] btrfs: unlinked 17 orphans
> [ =A0 42.232189] btrfs: truncated 2 orphans
>
> dmesg in 2.6.39.1 says:
[]
> [ =A0 15.004255] kernel BUG at fs/btrfs/inode.c:4676!
[]

I've been experiencing the same issue also.

Josef/Chris, would an metadata snapshot or full block snapshot help
debug this regression? I can probably setup a small testcase to
trigger this.

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
