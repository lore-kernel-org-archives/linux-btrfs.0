From: Martin Mailand <martin@tuxadero.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Thu, 27 Oct 2011 12:53:56 +0200
Message-ID: <4EA93844.3010601@tuxadero.com>
References: <4EA86FD7.4030407@tuxadero.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000108080707000205040306"
Cc: linux-btrfs@vger.kernel.org, Sage Weil <sage@newdream.net>,
	chb@muc.de, Josef Bacik <josef@redhat.com>, chris.mason@oracle.com
To: ceph-devel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4EA86FD7.4030407@tuxadero.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000108080707000205040306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi
resend without the perf attachment, which could be found here:
http://tuxadero.com/multistorage/perf.report.txt.bz2

Best Regards,
  martin

-------- Original-Nachricht --------
Betreff: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Datum: Wed, 26 Oct 2011 22:38:47 +0200
Von: Martin Mailand <martin@tuxadero.com>
Antwort an: martin@tuxadero.com
An: Sage Weil <sage@newdream.net>
Kopie (CC): Christian Brunner <chb@muc.de>, ceph-devel@vger.kernel.org, 
  linux-btrfs@vger.kernel.org

Hi,
I have more or less the same setup as Christian and I suffer the same
problems.
But as far as I can see the output of latencytop and perf differs form
Christian one, both are attached.
I was wondering about the high latency from btrfs-submit.

Process btrfs-submit-0 (970) Total: 2123.5 msec

I have as well the high IO rate and high IO wait.

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
             0.60    0.00    2.20   82.40    0.00   14.80

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    8.40     0.00    74.40
17.71     0.03    3.81    0.00    3.81   3.81   3.20
sdb               0.00     7.00    0.00  269.80     0.00  1224.80
9.08   107.19  398.69    0.00  398.69   3.15  85.00

top - 21:57:41 up  8:41,  1 user,  load average: 0.65, 0.79, 0.76
Tasks: 179 total,   1 running, 178 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.6%us,  2.4%sy,  0.0%ni, 70.8%id, 25.8%wa,  0.0%hi,  0.3%si,
0.0%st
Mem:   4018276k total,  1577728k used,  2440548k free,    10496k buffers
Swap:  1998844k total,        0k used,  1998844k free,  1316696k cached

    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND

   1399 root      20   0  548m 103m 3428 S  0.0  2.6   2:01.85 ceph-osd

   1401 root      20   0  548m 103m 3428 S  0.0  2.6   1:51.71 ceph-osd

   1400 root      20   0  548m 103m 3428 S  0.0  2.6   1:50.30 ceph-osd

   1391 root      20   0     0    0    0 S  0.0  0.0   1:18.39
btrfs-endio-wri

    976 root      20   0     0    0    0 S  0.0  0.0   1:18.11
btrfs-endio-wri

   1367 root      20   0     0    0    0 S  0.0  0.0   1:05.60
btrfs-worker-1

    968 root      20   0     0    0    0 S  0.0  0.0   1:05.45
btrfs-worker-0

   1163 root      20   0  141m 1636 1100 S  0.0  0.0   1:00.56 collectd

    970 root      20   0     0    0    0 S  0.0  0.0   0:47.73
btrfs-submit-0

   1402 root      20   0  548m 103m 3428 S  0.0  2.6   0:34.86 ceph-osd

   1392 root      20   0     0    0    0 S  0.0  0.0   0:33.70
btrfs-endio-met

    975 root      20   0     0    0    0 S  0.0  0.0   0:32.70
btrfs-endio-met

   1415 root      20   0  548m 103m 3428 S  0.0  2.6   0:28.29 ceph-osd

   1414 root      20   0  548m 103m 3428 S  0.0  2.6   0:28.24 ceph-osd

   1397 root      20   0  548m 103m 3428 S  0.0  2.6   0:24.60 ceph-osd

   1436 root      20   0  548m 103m 3428 S  0.0  2.6   0:13.31 ceph-osd


Here ist my setup.
Kernel v3.1 + Josef

The config for this osd (ceph version 0.37
(commit:a6f3bbb744a6faea95ae48317f0b838edb16a896)) is:
[osd.1]
          host = s-brick-003
          osd journal = /dev/sda7
          btrfs devs = /dev/sdb
	btrfs options = noatime
	filestore_btrfs_snap = false

I hope this helps to pin point the problem.

Best Regards,
martin


Sage Weil schrieb:
> On Wed, 26 Oct 2011, Christian Brunner wrote:
>> 2011/10/26 Sage Weil <sage@newdream.net>:
>>> On Wed, 26 Oct 2011, Christian Brunner wrote:
>>>>>>> Christian, have you tweaked those settings in your ceph.conf?  It would be
>>>>>>> something like 'journal dio = false'.  If not, can you verify that
>>>>>>> directio shows true when the journal is initialized from your osd log?
>>>>>>> E.g.,
>>>>>>>
>>>>>>>  2011-10-21 15:21:02.026789 7ff7e5c54720 journal _open dev/osd0.journal fd 14: 104857600 bytes, block size 4096 bytes, directio = 1
>>>>>>>
>>>>>>> If directio = 1 for you, something else funky is causing those
>>>>>>> blkdev_fsync's...
>>>>>> I've looked it up in the logs - directio is 1:
>>>>>>
>>>>>> Oct 25 17:20:16 os00 osd.000[1696]: 7f0016841740 journal _open
>>>>>> /dev/vg01/lv_osd_journal_0 fd 15: 17179869184 bytes, block size 4096
>>>>>> bytes, directio = 1
>>>>> Do you mind capturing an strace?  I'd like to see where that blkdev_fsync
>>>>> is coming from.
>>>> Here is an strace. I can see a lot of sync_file_range operations.
>>> Yeah, these all look like the flusher thread, and shouldn't be hitting
>>> blkdev_fsync.  Can you confirm that with
>>>
>>>        filestore flusher = false
>>>        filestore sync flush = false
>>>
>>> you get no sync_file_range at all?  I wonder if this is also perf lying
>>> about the call chain.
>> Yes, setting this makes the sync_file_range calls go away.
>
> Okay.  That means either sync_file_range on a regular btrfs file is
> triggering blkdev_fsync somewhere in btrfs, there is an extremely sneaky
> bug that is mixing up file descriptors, or latencytop is lying.  I'm
> guessing the latter, given the other weirdness Josef and Chris were
> seeing.  :)
>
>> Is it safe to use these settings with "filestore btrfs snap = 0"?
>
> Yeah.  They're purely a performance thing to push as much dirty data to
> disk as quickly as possible to minimize the snapshot create latency.
> You'll notice the write throughput tends to tank when them off.
>
> sage


--------------000108080707000205040306
Content-Type: application/x-bzip;
 name="latencytop.txt.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="latencytop.txt.bz2"

QlpoOTFBWSZTWfOs4fEANdnfgAc4QmP/8giixIq////gYCO/H3yab65K+B0c7oecrwAACPNX
u7gKFAUGMPTyAdB0HoooodXgGhlPVGgaUqCNBoFAUUEgAAAKUKFKoVDAAAAAaAAAAABqeJoK
pIgAANADSMCMAEiBEE0VJkAAAAAAASeqUpqkyZHqBkaAA00NAMgATVJIaTUjyTxJggaBtQAa
ZMgClJBJk0AgKangkA0yANDT1OYqTgEH74qTEQcgg8It0pkWBWKMkWUsiyLAMpZLElkkxlMJ
TMJWKn35RZirLFMUzMUwJqy1SVaNRbTNo0Ro1mkJkqSkyY1CmkywVYp41MUjZTI8+ZhgsKaU
8MKMqZelTZQl7q/H3P7SxOk7GZDMwMscVW5dj/nKZaMZNuCtqMWqxL2p8LnL+htV/1xS/BTc
c6nvU3ls6KdVZYe94qLcur6at9Vv9NbX1t9TcMiSl3dyu1BpIJBMYNjY11LfuIUND3CCWExC
pra95vXc50YnrqquU87kkZhmUN8VkWRZhTWFfCKk94qT6Cn1jayWYWGRZYTGWsaZGiqNYtFj
Ua7a111WNRt2rrqio1k0arrLWhZiMylmRMxRotaAxO1NU1Npsumdq6lfq18ZJL9P6mvfrdMG
v2fuN/TdvBmL7N3PpJ7LmnctxXVZWSxva/elE3FWLLzrbK3dvN46RtXpfG4t7ukkMJGdaOPJ
D64w0GvMr20FU973hXWU88m0hHfBdGsRQWrGeG0KF1HfXKWKZ01uuOqLb3d0l1cg94ZFZRyL
NsRSQFIrMEY94ZSrkANIw6RhDPdGlHuFl0AA2gS084Tjb4iW6im5mGQN3VUEqVLwaFGYyqzy
bSFOdhfW8kIs9je8YW3y5wzOF6bp32Xe9XZisrDdS9tjeytL7luPZV7irFaJXUqr6veA9/ce
8Pvj3h83i6i4i1UzEW0NxfWL7qcReoS9ayMph7MrSaaM1Y0zNZrF1c26aSuzdra4132/dJ7n
KyElA1cEWgUETAQMIYDjlApJaQ5ru1tu13SJd12EAzru05dIi1tSbnNygttSOuV3Ttyjt2q6
xznUd3R1113XdFbuu7uO7sFY0m3TumrfBq3NTqU8CUvWp818pclOimWimC+hTzKcQptwqeec
llbXemyf7cgv6tqmRo9v1MnTcrqrrJybyfjVqqeDIspfmUx6ujkltF+ZXUucbQuBMU+lTqG9
TuqUtBfpUaFiQwWRYpgsS1Cnz/i/H9DX4V9Br8b/KTPooS80XhyYKWL71vqgT9t4+o5l9sxp
8sXPpbFw4aU1HLxbZq+3bKa7N0GC1lIxkQHg9E4clK132yXrOXnblwl0Qqb3d4rUW72RUaNR
mTX20hOoHA03xh68YzLppb3eVXY5PRUWm6x3tEX1d3W8WENssJ1RspygLm1FhS4zu1U9qiXI
qrWcnXczKfJg+3LvC2NrUc2ss2ZnTRQPRZFk3jRdTSlfLyJhipZz1Ry9rblKqhjpTto8Y3y6
diDJvSyuzpu13b2ZLthEOlpoGLGHiN9XXQOBb2tEDomCKO37FdzyKOAwl07SAPKqNJ5V1Adu
EiIKiCbA2gFVaM3B1O5LJFgjUCldQqvYHw0IWFxPBgjLCVixek6Zr7bs+t0s4JbNCyZOdDeF
LKGb24aKo5wWjsFmrbKb8yRw6vIRalR9TISK5KqSKXG1wN3CLVyybuJK4vOjW9YoaMWFUhWG
Stpzbu7uyFYbeUiGSLrdCJIoFDTKHDhyHeSSxE1BW4DcZdIUuTXDg+SIFkkclhbnbEiCOyzS
N0wjZNilwIdghHidwFjcsniRytJgsnweDWzk14xeKvFNae0XorRt4v2pfKS+Fw5V9FTejMJm
LNY885YNMt9alm1TWxrG2yaxtl9KdFplD6wdgtgL8QIAA9d/I+Hwh/VNzb+qnGOYeOZZA2Md
kH1OYi6mbcAxt26khSREXEMqKmL7TVIafMkshWUQSGkSV9ihvBFEG4sdZjhthMwpYnMJNt6q
qZqLLHBUOLmGgSqh1uJJM1R8CSc7EHWxqiVNiE1L15vPK5du4IQte83pVzuOmtZq01lrMzGZ
4xfEWReRB81PnUH3UClIQQJI832wPT7jya9ZIAs9TD89uADxKuMAeHhxCzE0q0UedyTddbPW
rSWBrKiZuWk/eLSdMe8j7wDPtGy5dhUESWAlwpgAWPGu7RNtXi8Dgb0Nv3gajtVFQWjr14cN
9FdCOdj3a0ibOguB6HY0bdUndnwJFDhw0MMdfrAJ8KqOvVuKTwFFo1zvsu7z1keBIFarLFbN
rKVsjBauylepBy9HU6XbbBFnX7q9orxqVLgHTGlJJs+sKkakgKmYdukb28e74wBr+Cx2ytG2
my+XNOTXtDlxmHDMCPrOrMeiTsZM8T4IEMQaLrQlwPwPEYKrax9tDyB4fEY9RndblLbF9guV
Blop8td1DwsZ6/ZKHrNS1RIaFJpgwIMdYDh9GIm4URFDRtpuHZZsrkErzmMZcPgnidsqqTqg
XZtGd4HQ5nrq3Ne1XxJr49sxuDJmlZgD9SAKAoQVAxMJNQU/IgkCyCfNIJeRYKDFhiI8RItv
BQhincbunRNCr44Ey5KENPVJRutaJLfuhrtb3fPpeEEIZkeAhIA1KDXBCj6kCQSBYfqFYNCY
HwPB70vJKaxyEpb8K6xY06MvNFGTBb34I292JR2JOm8cWmxzAw0OHA6gbNGStlETjQ24hKBi
ooY1oWPgAeqjNnfG/Hxao3Q105bqqlwRPqdpemFaQ95kYNo7BcQ4GcaaDBzU5RYogerRwaYR
hKE0JBsaK97hUEsmcsw6esdQ24cvcr2TeBUifXYJ87pGy1zQvgXw3IHwXgLIZJZYwJoWLb27
siYEEROGLTDprh3XkvUrSHpU9YXcX8VUP0i/lU/ki2gPTj0YrMzBkZhfxHlmFKyPN8c7V75R
j6RpN8BLSC6PrZH0jR9TAxApgtpFFFsTaUhDQKBQ4UVCrpwgJL205zrqeYg2wN5NzFAED27G
iE+RkvB2ShIS07lQ0CaLZ7E9z1SVoFpwAPCOyDGN7IsBtdipinAdYnYppNIrri6+OZ1u+J8s
skPRKJZIHu6JFDW79tzfmEoXhlm63qBFFjxq9861vOZFxzFJoJ4HHLIHur16vovYt9GtrZfN
REkXwat7XmMq9dvZS7ul/Fum17TdFL326ga3NDeikakgIMFpApYJH09yWx/BkGAO0w+M9u7F
BECiMHySqHcEDO9TI+GaaJOzJHXZNjYyRq6olV9ACDsBNCEYfBI+GY+2jll2evo3vC5qqMVz
G/dqi5gykMZRNe9jtcmI9k6451RWA+JSve6ycy+YRfDsyuGEkwLwaBdIExgJnu4GOXA/CIXw
QKMJEKgyvbo1WE9cZ8qGYwlNKTRArcj6aBQ0QxVs1Z47BvNadxY1ni58C1ksmHcg5c5J08vT
qdj8aNfDCNeo+Zt613msz1xFnLIJ45qoOaeZfRwQo6KnhZUs4IUlb6GRBHWYuRipDx7dtcHE
daMZONBU8t5dm3LRy+nVEJNwmuCSEfHLVBKZ7kptnoa9iYUyWWgT5fLNdQ2uvIhi0zbUAkaF
ykge875zBKOc36FmTMmGYPjOnLN8Wra8XTbgm9YdSiCrmmY0HDSxKI2wDo86jmi2g0JxMCGD
UlVuhBbFw21kVE00kWNFjAPh6BKLJIXXkaOdk+31wStbLvwwkZzBD9ayBdiAZ31riaqe2yps
xJCXQjaA889+m0hHI0IlDOTkmN1BRQaMgo1nJR0Cx2ZqshCwMkFD1DIOFAVgJhzFMW2Tey7U
TWP14QbZuIphDXDgbPbIHC0XQ4qZiGDacuGMZ217F4AJ2gXQpSAXIC86ftm1qPYxyPqyy8Zh
XGHVm3xrjCOlvQQ/qkvPmeCfKe+XISgxw7GRbsQUi6JggFyX8lEnh0Tjpvk7IJPtifp/QfBE
yHHJqR8oFEJjkns9lX4gUEL5qNV66AEGctNpsTabbGxMQc8fDW+FlQXUHvvo+fRY0bfyfl17
gnL5DitIhes/Lb0T5cuzvgQ5i6Iy2RPEa3APsBaQLg9HepfcKCvXUV1yQsr1uuUA6rWiV3ZD
wBMaBRMCRchxwdpCA6QtNppjbG2NpL1dnTijguzgyM+NDHziCt+bWDMviPns1gNAGtxZ8fAw
Od0OKHzNVmivRy0V13Mtw8kUcUAsJe7libUj8Ign05eUEjOjWjXe/EIQdemki9GDIyO+tSTf
cuoPF56gONmGKru+C5zdbyVOX0QgUWJHkbgkSHg6iEKuplEpv4i12xahWBv48bHTLTDfiL6x
fnSBDQLtAvSQd9cyLtk1VgKqmpcTLiZjbb+FI/jF5RZF/Mi1F/sRYi2rVtK1bXx7sAJMySQz
JASAABISAAASmVEUERgCiyRJCQAAAAEgbWAgAAICQABKrAAAACQAAJaCCAASASABINttt+v5
qlfl6rmvzNfcopSfrQm2XJJIwU1VElAiJHZCIV9W6bXqVXjY0Vzc1e6eXnV1JL2dSl51znS5
u3ZO3peTFeDrrj2bynjJpe128l4put10k6XTNeXc1Kl5N5LeW6u0qxg1qjFaGra0H6s5ctYw
xjGxH64yOMmmeDK2bMpjJxloxtNiUySkkpJZKSlJai1gwi6xfzRd9GZlMFlSymBb0v7UWSX0
5S8gv/Yt5TS/0S7Uj11JcoPCUrS50empiN5NeAtLbW6wXYiwLZmBvFqjSvAWgulLQsrvWVhc
5QxU/hFyyLQblbA5imRYPktOIXWLwpbUu8XEnQRNyvB5Nt3NGirIl0pHu4hs8lTyr7tfY9/U
qjVCbCiaiqauFXSIryi8qXQc1RiczhXcLYLKiZQ8AcJMdUDgnUVwJcVWo6vIphTHVN0XCo/y
PNPKTp4T0qjxi8Vsi8WMsFlMVO4XiVyL0FqLeFxKNOULgRNQndeRilmHVo1FktyLhb0dkcEu
Kn5E4WlNq5HAXFUbG7FOItRYS4XdesmqhqLeporulMKmNy2ZDhJfDjIugSOKnFSmKdEV/JQn
wi2pE8hHVEcC6xZK9Iq5oOqlidHwiOPOF4oV2VR7FOUL2qdqN+1TFPKLKpfZFpFkX3RbBX7I
tk3KGRYYWVssGitWk1WFMspiymYmYWVYTMGoxLVRwUslhYtVimJbJYNJqguwlLuUxQlinslM
VMUxJim1Bf4p3KbqdKUWom0l5YlsSWv80jmcqZEYxTq/KLEDhKcxLdVqj1/D1F+XjF4Rcgpv
H7YrFNC1mym1TWTMxgSMSMkmi2Lb3ba81brVhGCJkGitKtYYmo0mUX2VPrd5O/+6mV7A9Yv0
Sq2F4SDFI2qHyZMGYyJfNtDuJdyp6xe8X7k0fEmSdvxi+UXMXLipn9TOkm5Lalhb0OiRqbbW
FMkeQmyTRV0lpU2U6NSZuVsG7CufvBbSGVRyk1VeqLoaFtF7MdITVRKweKVBi1KrP/ov1U1F
4D9StuAZMzDzEsEOKksI7dxEyV1XAidiRzQe0NQ+B8qtpGlaH1i2qfSSe5FzQd1gu9TKneFd
wk0U2U4UpziJ9gsFgXxQsEZEVhMQv6RewOk+T4IuiuREwL4lHkTsV3i7kU+hF51HCLvF0Qt5
F3FTZEMBPVFeH1GgL1KpyVTQL3qfCpoHkxA+IvBahYbSC9ysSrCsCMWULFTaL7yGKXIm5PPS
d6nH4lNKYkXJTipyi2JqLmL8TiTzRHrF8ovktKTZoLWIjcim0gXweake8ieMW8J+kXo+3zi5
B1F6x4xocKsrMGR6lMSWQtUdJRkS7JTZFvKrUhkXuDekcRHEWSYn1i1SxUxdjKC0SwyTyko4
oykr97TxF9wvOr2TJijBlUcsTrSMpGEXVFspE5BTzFpTjzFwFgsFcFMIq3hip1ormiypllY5
lReXSgxKLQXzBfeqMdRuuN4vnUlxQe30PeqTui7IjKowWf0i2TxSmUsTKR4eiRsHnikrYl83
mIneLtFtSOk7ye1+5T0i8G1MRHZFlBidWVRlUcVHdF81U9FU5VeGHmQDpFuld6ZllVkGCTiK
xAyLZ2EfiKOhV5yspRzSOOBE2ItRbxZBvJ3jRmMo2BahbwjKJfWlhWRJko+IuhFMJLUS9JPa
Q2/Z2SvlAfFVOiU7pI7dEj7SfkVqoq71XWIrA7q9l4A7PAiTsi+cXUl1T9qRMk7SeYj1qjsU
5dpOYpXsqfCOaktSaL3i2qdEDCsJ9kRvfOLqImheCsC5i6HRF96X4kuJPtDqcLzkPAi/BTaq
O9DYmMJRisEYGCyVlBYyIrFYTxWIW0WwLUXkpbofSVS7rqnRNhExVsbJoqfEqukjwT5sKrIu
3CeKwBw4RVPmqaItjQId07kSbq8xGCJ+ZFOar7B+UnlIcrkLzyU6sN4tnpeCyp71NouA8dZL
rS1iu1NZ3BTSTatSehTItzamgXrFj3FzVF+5eCbC+iLcK5ix+FLAWFYDAZBlYWJgZiRWQuUi
66S3i9otKXiQDFvC6lakPJWVcVR6g7+oXqIyhhV48kvpIdYuphFM8KRoi04RHWe6I/CLtF40
j7+MF6xZUXLJ1CYpiqyyh25LfDMoZkjLMyZhmGYZmO8nt60xO0XZ51GRcRcTgjZtS8qWKnMW
80nD7nLaLYrlTWRmSZFsRbaiwmyTVLtDC5TKVPBFsjjMtkVzlNW6nAWrFOKnIhOHdU56SFrA
rGNkRkPyRWUWpgqdQTdEae1KTzqBvIuxKsUm8pXkqjgEvxTJNxaRVPGTyF2CvJC86nlVdEGy
U9SlOdBeipPMpx0RPRV5WwjvKnku8X3pHkZN4q9QTzSK7lTxK3divpT6WlarVGZFs2iO0mUt
n3NCuKGVRvFi4k+yL0hcJdGYxhmMYFN4UxUxU5RcYWSl5LcWpXAWUE8QT5K0mRWWIyyOim0o
1JdaWyPHIj/xdyRThQkPOs4fEA==
--------------000108080707000205040306--
