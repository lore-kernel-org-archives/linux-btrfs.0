From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Re: Errors in dmesg, no crashes though.
Date: Mon, 27 Feb 2012 14:58:29 -0600
Message-ID: <CAB3q874sxdP8Y8Bs=NMhkceQ4VFqJSDOGe=hXvUOLM9k205JWQ@mail.gmail.com>
References: <CACCfv7p=w3j5+K698nms0-T1XJLXg=SWhQQ82jf7yvSUt9nYPw@mail.gmail.com>
	<20120227150346.GQ1046@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Jordan Windsor <jordanw2@gmail.com>,
	linux-btrfs@vger.kernel.org, josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120227150346.GQ1046@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

I've just seen this too on Fedora 16 while I was investigating an NFS i=
ssue.
I was trying to copy a file from an NFS mount to a btrfs partition.
The NFS transfers for large files were occurring in bursts for some
reason and I was aborting the copy at times. This NFS problem was not
related to btrfs (cat NFS file > /dev/null was also bursting and
slow).

Originally I ran  3.2.1-3.fc16, but just upgraded to 3.2.7-1.fc16. The
file system was formatted with 3.2.1 originally.

I can't say for sure what caused this - whether it was the NFS being
slow, the copy being interrupted, or btrfs itself.

Regards,
Nik

On Mon, Feb 27, 2012 at 9:03 AM, David Sterba <dave@jikos.cz> wrote:
> On Sat, Feb 25, 2012 at 09:14:01AM +1030, Jordan Windsor wrote:
>> I'm running Ubuntu under KVM, with btrfs on the host where the
>> Qemu/KVM image is stored, the VM was also running at the time. I was
>> going to check something unrelated in the dmesg output, as I did tha=
t
>> I noticed some errors in it about btrfs here they are:
>>
>>
>> [ 4294.431807] btrfs: block rsv returned -28
>> [ 4294.431811] ------------[ cut here ]------------
>> [ 4294.431831] WARNING: at fs/btrfs/extent-tree.c:5985
>
> This is a warning and it shows up from time to time, accross recent
> releases.
>
>> This didn't cause any crashes or related issues, also unrelated (I
>> think?) is that I get very low performance (about 5MBps according to
>> iostat) in a guest under Qemu/KVM.
>> 3.2.7-1-ARCH x86_64 Arch Linux
>
> Yes, the performance goes down as some pathological should-not-happen
> code path is taken. I myself haven't seen this error recently during
> testing, but at the time I did, it slowed down the machine for a whil=
e,
> ie. it's not a inifinite loop. Seems there's a dark corner of
> space reservations left for Josef.
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
