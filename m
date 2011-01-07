From: cwillu <cwillu@cwillu.com>
Subject: Re: "open_ctree failed", unable to mount the fs
Date: Fri, 7 Jan 2011 13:47:17 -0600
Message-ID: <AANLkTint9312XUw3LqHWTyP5_LQTaUgRzXE8KfBdbYta@mail.gmail.com>
References: <4D276899.7000702@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D276899.7000702@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 1:25 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> The forthcoming[1] btrfsck tool should handle that particular
>> error, I believe.
>
> I noticed a similar problem was discussed here, with a solution:
>
> http://www.spinics.net/lists/linux-btrfs/msg07572.html
>
>
> where a "btrfs-selects-super" was used:
>
>> git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
>> next
>>
>> (or git pull into your existing checkout)
>>
>> Then
>>
>> make btrfs-select-super
>> ./btrfs-selects-super -s 1 /dev/xxx
>>
>> After this you'll want to do a full backup and make sure things are
>> working properly.
>
>
> However, I don't see the tool when I clone the latest git - am I missing something?

It's not built by the makefile by default;  "make btrfs-select-super"
as stated above will make it.
