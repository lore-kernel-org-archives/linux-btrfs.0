From: Timothy Crone <tjcrone@gmail.com>
Subject: Re: Segmentation Faults
Date: Fri, 18 Nov 2011 07:29:52 -0500
Message-ID: <CAG+2MKL7ynWwuv9_YUOTEtV+25coh0TJEOc9f8cu_2nx2Fktdw@mail.gmail.com>
References: <loom.20111116T171334-175@post.gmane.org> <20111116230045.GY12759@twin.jikos.cz>
Reply-To: tjcrone@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111116230045.GY12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Okay, I installed 3.1.1 and continue to oops when trying to delete a
directory. Please let me know if you would like any additional
information. I'm going to rebuild from a backup later today.
Cheers,Tim

On Wed, Nov 16, 2011 at 6:00 PM, David Sterba <dave@jikos.cz> wrote:
> Hi,
>
> On Wed, Nov 16, 2011 at 04:39:21PM +0000, Tim Crone wrote:
>> root@berna:~# uname -a
>> Linux berna 2.6.38-bpo.2-amd64 #1 SMP Mon Jun 6 15:24:02 UTC 2011
>> x86_64 GNU/Linux
>
> 2.6.38 is quite old from btrfs perspective and it's highly possible t=
hat
> the bug you've hit is already fixed. Try newer (like 3.1) kernel and =
if
> you still hit some sort of crash, please send the report.
>
>> root@berna:/home/tjc# rm -rf .cache/chromium
>> Segmentation fault
>> root@berna:/home/tjc#
>> Message from syslogd@localhost at Nov 16 11:19:35 ...
>> =A0kernel:[ =A0 66.877568] ------------[ cut here ]------------
>>
>> Message from syslogd@localhost at Nov 16 11:19:35 ...
>> =A0kernel:[ =A0 66.877572] invalid opcode: 0000 [#1] SMP
>>
>> Message from syslogd@localhost at Nov 16 11:19:35 ...
>> =A0kernel:[ =A0 66.877573] last sysfs file: /sys/devices/virtual/blo=
ck/md0/uevent
>>
>> Message from syslogd@localhost at Nov 16 11:19:35 ...
>> =A0kernel:[ =A0 66.877633] Stack:
>>
>> Message from syslogd@localhost at Nov 16 11:19:35 ...
>> =A0kernel:[ =A0 66.877640] Call Trace:
>>
>> Message from syslogd@localhost at Nov 16 11:19:35 ...
>> =A0kernel:[ =A0 66.877703] Code: 24 24 48 8b 74 24 28 48 8d 54 24 50=
 41 b9 01 00
>> 00 00 48 89 d9 4c 89 e7 e8 80 6e ff ff 83 f8 00 41 89 c5 0f 8c c5 02=
 00 00 74
>> 04 <0f> 0b eb fe 4c 8b 2b 8b 73 40 4c 89 ef e8 a3 e5 ff ff 41 89 c6
>
> btw such output is printed to every console when the crash occurs, bu=
t
> lacks important information like stacktrace and names of functions.
> without that it's very hard to get a clue what happened.
>
>> (I was going to include some log entries, but the lines are longer t=
han
>> 80 characters and your system will not accept them.)
>
> As for stacktrace and line length, I personally want to see the lines
> not wrapped at 80 (except the eg. byte dump of instructions), it help=
s
> readability.
>
>
> david
>



--=20
Timothy J. Crone
Lamont-Doherty Earth Observatory
Columbia University
61 Route 9W
Palisades, NY 10964
Tel: 845-365-8687

http://www.fluidcontinuity.org
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
