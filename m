From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [3.0-rc1] kernel BUG at fs/btrfs/relocation.c:4285!
Date: Tue, 31 May 2011 15:58:00 +0900
Message-ID: <4DE49178.2070403@jp.fujitsu.com>
References: <4DE43607.2090105@jp.fujitsu.com> <1306804322-sup-3529@shiny> <4DE46F33.6040706@jp.fujitsu.com> <4DE4870E.4020307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000208040006040401020901"
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE4870E.4020307@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000208040006040401020901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(2011/05/31 15:13), liubo wrote:
> On 05/31/2011 12:31 PM, Tsutomu Itoh wrote:
>> (2011/05/31 10:13), Chris Mason wrote:
>>> Excerpts from Tsutomu Itoh's message of 2011-05-30 20:27:51 -0400:
>>>> The panic occurred when 'btrfs fi bal /test5' was executed.
>>>>
>>>> /test5 is as follows:
>>>> # mount -o space_cache,compress=lzo /dev/sdc3 /test5
>>>> #
>>>> # btrfs fi sh /dev/sdc3
>>>> Label: none  uuid: 38ec48b2-a64b-4225-8cc6-5eb08024dc64
>>>>         Total devices 5 FS bytes used 7.87MB
>>>>         devid    1 size 10.00GB used 2.02GB path /dev/sdc3
>>>>         devid    2 size 15.01GB used 3.00GB path /dev/sdc5
>>>>         devid    3 size 15.01GB used 3.00GB path /dev/sdc6
>>>>         devid    4 size 20.01GB used 2.01GB path /dev/sdc7
>>>>         devid    5 size 10.00GB used 2.01GB path /dev/sdc8
>>>>
>>>> Btrfs v0.19-50-ge6bd18d
>>>> # btrfs fi df /test5
>>>> Data, RAID0: total=10.00GB, used=3.52MB
>>>> Data: total=8.00MB, used=1.60MB
>>>> System, RAID1: total=8.00MB, used=4.00KB
>>>> System: total=4.00MB, used=0.00
>>>> Metadata, RAID1: total=1.00GB, used=216.00KB
>>>> Metadata: total=8.00MB, used=0.00
>>> The oops is happening as we write inode cache during a commit during thekk
>>> balance.  I did run a number of balances on the inode cache code, do you
>>> have a test script that sets up the filesystem to recreate this?
>>
>> Yes, I have.
>> In my test, the panic is done at frequency once every about ten times.
>>
>> I attached the test script to this mail. (though it is a dirty test script
>> that scrapes up script...)
>>
> 
> I'm getting it to run, hope we can get something valuable. ;)

I executed again, the write error occurred though the panic have not occurred.

See below:
=============================
...

+ sleep 30
+ ./fsync3.sh
Tue May 31 13:50:57 JST 2011

+ btrfs fi bal /test5
+ wait
write error: Inappropriate ioctl for device
cmp: EOF on /test5/_de100.t

...
...

$ ls -l /test5/_de100*
-rw-r--r-- 1 root root 3000000000 May 31 13:56 /test5/_de100.f
-rw-r--r-- 1 root root  607789056 May 31 13:56 /test5/_de100.t

write error occurred by writing in /test5/_de100.t or mistake of
error number? (it should be ENOSPC??)
(operation: copy from /test5/_de100.f to /test5/_de100.t)
=============================

And, in my environment, it seems to be easy for the script attached to
this mail to do the panic.

> 
> thanks,
> liubo
> 
>> Thanks,
>> Tsutomu
>>
>>
>>> -chris
>>>

--------------000208040006040401020901
Content-Type: application/gzip;
 name="RT2.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="RT2.tar.gz"

H4sIADqQ5E0AA+08+3faxtL5lf0rxhi3YAOWxCvBdXsSm7Q+9es6Tnvu53AICMlWDBJXEjdO
0/zvd2ZXEivxEHaDk3xhj41Wu7MzszP71sxeXGq7T1YcFAyNWk0869XYMwhPVLXWUFWlweFU
RW3Un0Bt1YxRGHt+1wV4YvnOzSK4tPxvNFyg/t3+e7fjG56vlb1V1DFF/1pVqwj9K3WtWlNR
/1pdQ/0rK+BlKnzn+t/cgN2eZe96N4xtwosP0DfM7njgF2HsGdDtOWMf1Jpy8gIcGw4t75Zt
ss1MOd5mwLQGBlx51l9Gm7EylHf/eH7B2Kuj/2vt5z5qzRJiUD5lNkPkhPH3F4yZjgt/gWWD
AipoUIEq1KAODXgKz6ALPdChDwaYcA03rO8wwEBlulNleBZCZCi7x7MVUFRQNFAqoFRBqYFS
B6UBylNQnoGKpVWWoRIZV99XGD43QXeNrm9AjhgH19Adt4/p5V2R3ul3/S6U9CA/p5Zz3XKu
V1Jyf8HPu33jv7v2eDAQmLBAH7p2H967FmLMqwWOiJI7IilWPHpRY7jgh+VKaQ8qVZku9b5r
+VQBb2AYI1BFXfqWaYJ+Y+i3QT14wlz+hURzvywG1ELAt8bdyIWcq8MO5H55u7hUZV6pmULX
lhR69UHiqz2oVD1N6JVpoWspQq8+SJa1B5WqL9CAZcIVTynZBnbP9h74N4aNGRlDv3Egm51E
N3AsQRqmM0Z1bUAzIiDBZPioElHeRv0Ou5Zt9LNJlHeWD88wZlqM+rRt4GMTvA+2jgIOhgZK
pJg7hBKv3HbpSik9a2N9mMjlaHAk+NJD8qMGmv9PurcGyXpVNGiSr1er8+Z/lRZ7uPbT6g2l
oqi0/lPrWm09/z9GoNk81D9GedAUpVpWGmWtAXBZPsKKM3ZwAPug64ydnV9irHTNTs4uWgfn
5/TyZxfnvaNTAmEHL4+f//oKY7k8ghbwEQBSFGEK7PjoBebz8kGUXZxgAb4OcYfs4LeTs8Pw
Xb8ZOn1cSlxw+pN5uKyD0bf8MD4Zd8s6O//1JA48AZUAGUOuceDJIzgOsLk8p1uAnTvYLtNy
SELQjJPm0AdUIVHbApScGL04o7k81TMUBY/jaBOy1JQrMhPzhHu5yjOxTqrXjMtkFl5pspJh
Z2O2bOwoKDCUy8Do2k2WKeXyFycFGk2l6srJEbdyoqQA+L6G2q8y0PiPi/WV0kgZ/3HgD/d/
NVVpaLT/r1WV9fj/GIEdtv5Q9/mC1OvrFf7asfezYUoNwlg9ijWi2NMsFdDC8v0qf6XyWcZO
Ti8RM+0RaxTXRLzOMzo4N6j7WRyEvFFXNzp6F9e6Rd0ZjlzD8/YHfznZEEzjyA6PLvYPLbek
fmfrs1UH6v8mrZRLSmU1pz/p539aLVz/qbVKnfq/pjSq6/7/GGFTPq/xnVG+wD6yzK2Fe9PS
ZQvXZbmR1WefGPPd7giyBLIHfKekZuG31+dwdHoJ/3p9dAnnR+ctoCKM5aXzIWpVkKP+v5vD
TrybU7E87d1KNmSTcIbdN/pNyO4BLhuMAuD2Dcnv5zYY47vkLy2t/3+Bn/9Ki79V0Fg8/9Nh
v0b9v1HH7V9DqVL/r9bW+79HCbvbDLaTJ2fUH4Ev3GE7I+0SrkpuG3960PuAb3/TWajujG2/
DabrDDviFNh3eKSNZak4D39icd+wsVwz3FHC9i5jm33ceNoGdI6fX/zaenl03KpXO6/OXl8c
tDDTsvXBuG/AT57ft5zyzc/xpIHVS6a5ln0dTxvbFoLG00zd9gfxJMN1bU6BGXe+4dqg33Td
zLYzwsZxvRcmWrafwSTL7hcBn1iIP/Fvb1KX4+PO0enLo9Ojy39n8spdw4yH4+NCBDoLrjDB
9OL1yw4dNWfyODli3yjINCaZlXAelfKPTlsSBE6wiHZse9a1bfRF3Xpj8yqEaO8lMgeDDuVL
ZKZBkI4AkmkhGO4UfUYHdXmMAIpPL/ISsI3x/161+QRDktT3xLNnDq4RhP+6+BskDww7iJkd
EwXu42+QgILHmFARtbwibPsOpgwc+xroJ8ObZSyFmmwswSpCSGCIT2p8iG2EFcgI3cI+iF+F
0ohLOlUQD1c8MIcjpgyiGCS9v6GekM/r+H5tUPvICzmQBIqQ7TX1ppstFOBnhC/ARzr8fW/5
+g3kdfGqdz0Dfuz92KTzTSK9s7PHo4JY13cGg7xonQWeMcKm75v5bACwNRj039jZIu+pAqKH
Hfl2L8KtC9z6BHdYg/nIQ4gIO0+Yid4V6F2J9TjALwLADHBjJ+XdKTu2b23nvU2igi2dUxFd
TJBBoCS+Twz/GJ0+57mSfviBa0kIMoGfCkL2tde9Npqw5aWMaDSYtYkFlgkCb8JKm/NCq6C8
StGQPDWXDVQp/P23QPiTiAu5/RTq+lF52ghlsjERStSgknITrSdqlEFjkkY0ohFrap7hg+80
eZMAHMbweVeIWt6k/X0CY4BqJ2J6qCTRmiJqYeuaQ05kz6fH86UmGdaNdz0ogRi4C0RQC/RA
4tznnfJK5O7stGWSAcCWxwnQGxey78RLxcpgJkzK+E6i8m6khDm8qSJ3BnPtWF+cw5tg7vT1
8THvGoLwxxk9jbc6DJ+p4Uktj3fICeEpujAJ9ycO81u7aQ7G3g3RccbUAgL10+yBInFGhp0X
k8VZ5+Lw7PT433+fTdYdOBjP65+QpbI0FzguctqUZV4EXHTwnDxfQhQmfGmxXpjQu8+ZYkIF
nDXfIcb+vAgYO7hoPb/E5+XF69MDmdEiKPV6VWZ3SX5DtQFRmsW1xHZyTBWEbBQj185utDQh
2GGYvCUlYzpO4PRxQCUY+iyft/j0CBaybuNjZyfgn0tEQNNiMy/me1xbFCOEsfpOV5ivX3mF
krWdWVFR04p4+ST3Ko4IBC9bYo7DF96YBJ88a3/CSjQLcXllksoWCXz1zHUeVItw0kzBnwJu
ulJizX2PWsWqJeoVVUwgm1GxAPITrbdNUEhXdBzElYDZm7glt0w2XTEB5QuooPahgPgciCP8
kMfStTz8atT7baouObtOBpqYxpJcvrFLehNsxwdrOBoYQ8P2DazmB8NHItKQUJ1oWB84nhG2
jXAwM0fImSkNsFm+uN0X89A86uZ9R1XBTC0cnzK4FECNmIaLDKBI+JalKG+NBIvR0KPyoSdY
qSfHHxPX6V4+3NQU4zso5GqUrE+s5+N/RloD8MUJ4fJ4U+f1snCaVwOOAimOgtfEvBVUVJFW
DjNnpTf2kU3b0u5ASHFjI1TbRFCTbj2zV8eaSLz/+3HI2RNsrDkkG5zIDEcIQhDViw4Uv/TJ
xzpQiM7/V2T7SSHN/lOtqJH9b71O9p9qo6Ktz/8eI8jn/3TmzkK7KlYOvwtxC89O31AUOo8X
VmrajHw1nr85BaBxgM35GCppGKppGGppGOppGBppGJ6mYXjGAQIUz6YAzGtZkJUZ+Wo8P8mC
eR0T5EyISipENQExBVBL4bKekt9IyX+akh8To6op/LNSwhJXC4YQ/oFJ3eWNUCmbkoXlHrxh
ELfLjIPGXv1kSX04QjqDxYUKEz614ENVWC/kepPbMY2H/PiCF8Qkj9JMT78lk5iSHaVTsoAM
kthSHDBhevkLlIz/kOUlE4aXga3jwpK0vmDCmvLHjbhZJrfLXFT4R0YWl+GIwYeP79OK8tsN
0fy/sq//6d//69z+k/t/qFpD4fN/dT3/P0pYYv7nX+Y71zfKvJkxBFDnzYwhgJaGoZLAMA0x
dwUQAsxdAYQAc1cAIUBjzjonzH+akh9MXPI8oM2aB7Q584A2PQ9oc0bZf65//v1/bK+u8z9J
7f9qVVEj/696tUL9v4JbgnX/f4Qg+3/Rt5XSnTQgnD+//G1/d+y5uwNH7w4IsCl+KI1HqAGT
QdDIcX0geMaOn5/+un8QJdLrAtsidSoFG3vogFRjYe7vR8fHcfgoRaPThLHdHRpQ6jI27N4a
wG2UeRSz5KVXrP+xTXc4dPrQ813TYxgbuU7PCF75L+Bq0NIN8HREx4a3plcW6TkylBS/HSQU
IeWGjWEupzi87VsulEbB2omMoKYwaeJ3CpMW5nJ2Y5i0AJNsl0VjQ7p1lvg67btjg3zqMmJA
yZQnxwDklUSS5nZXmWglmxH8mhb0uoNweZqWXZ6sLgK0moy2/iC002laOkY+HksNK/D6+dId
8AuHmP/vitaAKeN/Va1E6z+tptS5/2+lsh7/HyMs4/9bURb4/1aW8f8lEyXZ/xfff3/BXr4+
Pwz9CLlL7S5U3rLfkqlvtkF7u8hZeLFrcOhOfF8XYaULSg8UHZT+Z3IUdtzrpLOwjIzEsQgZ
z4+QjUf95T2PSaQ5EizG8/pomqWJsye+0ckHMTDxOyo5kItRV2KFAl7CcjOdYONuwvhWSPrB
SnonWjvAOX6bzrK6HMvqfVmOFVDVz8mythzL2n1ZjhVQtRksx72NteVcvKeUx+Y6eU8JjS3n
ZDzF+exyM9u4Vvgnuqgsp4vKfXURK6BWPmfzqS7HcvW+LMcKqNXPyXJtOZZr92U5VkCtLWjx
6U71Uxpbsu1OiW3JclO8z23zX9S1XmXctT4zcaKX3ejJgX7iYv8du9J/k4HW/xet54cnrdXR
4Iv8Bf6fajU8/6lpWoPW/6pSXft/PEpgapn7aQOu2Pkyvkyd+bD1xzafYHHvvM2YhjB3hj4m
R3F+Vgi9D+A6js+BjbtyMChsgu3cjEf0vU2A/bAeAr7yQP0/dlvBCmik+H9Xa7Ua9/+qNRrV
hiru/1LX/t+PEoT/V7AFjfl9JbafwvyeXxMSOHbxlCbYcCU2rW3AzYOIkrWdopBRsFeQ/cC+
K0ews9NW56J1QN5bkmsWpnROz3giJSe8qvzhiDtVBWXbKMiPuN77lPS+QjGHMDuqBJUAe+9y
bIJmO8L6ACet2b5X2Bro3D3Isorwrgi3YbauprhkDRxnFEuI/LGc/jw3rPu4WenNJXysQj+o
z+n8tBLfJtm5KHAo2p/rsTDxq4h1XVJWihfFYreUEMkCBxgJJDTpDVLSDFofzvQ814+J40eA
Z0kfi9BYO5P0tVjWNSQkt8jqO+4lQp0hciPcDYYJzKPvU2HyVpSMHUENesFt8OR2zrawc7ap
bfDuBXZo5px0wQhQSXbQHOKdgHiHEPlgvCDLZVWYL8O7CDoaq97R+IPs7IBypymSL4QXCAsH
K5TUlqIq/VBAt0UIigfG90NjqI8+5IMBy2oXgZcKOJAs9PP5nR0dW6OgxtsmOc+GTEViCazo
b0WPitwThD0/WfMLUkWgU2vHDCgXuG1/Mmm2AfsMI/8FdusVya8mbpItmVmLdosqn60yGhe/
e32ReHDJElLiCptKe0SNzbWKFy4Skc3712nyLt3/sjIL8Hvd/6KI+1/q6/3/o4SV3/+ihfe/
qIvvf9HW9798iUD9X7pVcCU0Uvb/lXq9Ft7/qTX4/Z+aVl/bfz5KEPt/fgIY2/1PvtFclRxw
TNMz/DZ4ztjVDXHRy3jUD88HOvKxgIAFfjBAJwDt7/YAQL6ipTJjs5+4guXee3Jn1mUpHndV
Hc++LMVzEec2ag5TUE8dP9DWvN22M7nmJFDrcjtvZ5mdtyN2yc7kipCIBu3CZ27CI4itYBMu
Er7MLjxgZv7mUL7dQOpErk6d52H78ODqCsKx6OYK0VGFXQ4P0WYcS3JqyMGCTbzo3Hw0EEii
8piz/D7+/tWes5P3pEsceCOmOxz+vPiHNzhwTMtd4JAfSxxgNT7bLRIc13I8oMCN27zo4EKq
RXjVav3eedW6XESYl1ti2zPZ9XBN0O5yb0+6tEJy3h+nXNGwhAv/gp1X6HC+nOP+jGsZpJ4b
20d6i/z4P9d2cQnH/UXe1F7gMC3exp1vYx+5DuuwDuuwDuuwDuuwDuuwDuuwDuuwDl9v+B8M
h2ziAHgAAA==
--------------000208040006040401020901--

