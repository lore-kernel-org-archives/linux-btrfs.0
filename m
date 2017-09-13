Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outprodmail01.cc.columbia.edu ([128.59.72.39]:39562 "EHLO
        outprodmail01.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751318AbdIMQOd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 12:14:33 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v8DFq9mh029090
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 11:53:38 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id D87A07E
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 11:53:38 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu [128.59.72.14])
        by hazelnut (Postfix) with ESMTP id BD4997E
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 11:53:38 -0400 (EDT)
Received: from mail-wr0-f197.google.com (mail-wr0-f197.google.com [209.85.128.197])
        by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v8DFrbmG026799
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 11:53:38 -0400
Received: by mail-wr0-f197.google.com with SMTP id k20so621434wre.6
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 08:53:38 -0700 (PDT)
MIME-Version: 1.0
From: Ruoxin Jiang <rj2394@columbia.edu>
Date: Wed, 13 Sep 2017 11:53:35 -0400
Message-ID: <CAFzqJcbAYFXsUjfnHTk9VT=PPsVUibh1-qf_p2oWt490cAdHcA@mail.gmail.com>
Subject: Btrfs Issues
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="001a11469e6eac046a055914293f"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a11469e6eac046a055914293f
Content-Type: text/plain; charset="UTF-8"

Hello,

We are researchers from Columbia University, New York. As part of our
current research we have found some semantic discrepancies between
btrfs and other popular filesystems.

We have attached two cases. The first one involves an invalid O_DIRECT
write() that fails back to buffered write instead of failing with
error EINVAL. In directory 2, we discovered that btrfs calculates
write_bytes in __btrfs_buffered_write differently from that in
generic_perform_writes in fs/mmap.c. This can cause inconsistent
behavior between btrfs and other filesystems when program invokes the
same writev/write() syscall.

In each directory, you will find a Readme.md describing the issue and
pointing to the code that may cause the problem. For your convenience,
we also included test programs (min.cpp) and instructions in Readme to
help reproduce the issues.

We would appreciate very much if you could confirm the two cases at
your conveniences.

Thanks,
Amy

--001a11469e6eac046a055914293f
Content-Type: application/x-gzip; name="btrfs_issues.tar.gz"
Content-Disposition: attachment; filename="btrfs_issues.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j7j73r9s0

H4sIAARSuVkAA+08bWwcx3V7pCiRZ5miHNlWJDWeSlZ6J5HH+yYlWdIdP6SjS0ksRTmOPrJc7u3x
1rrbve7uSaQTtTbkGCYot4rzI0J/FEKbAkaNAkZgFIrR1hIUWE7QogqQBkJboGoRt1TiFEzduCpq
m30zO7O3O7dHSa4+WpQjHd/Om/fevPfm683c3kxYRsEUVdOsKmZ3rHtUkfJlJVLOC3cxRaPRdDKJ
AMZ6UlE3JCneE0uiWCKWSseTPWl4jsZSsWhCQNG7qUSjVDUtyQBVpPL0onS3KrdtQQ78P5IOVstl
yZgO7rydFAzuQkMamsB9phNJqKyaUkmd1JQ8Gj8gDgyNDvaPjaOThmopoTAqSKWSiSYk+TiydDRR
LRQUAyhJMVI104K+hvQC0KmlkqpNopOqVURdg0P7n8kOo5J6HFMh3SoqBqrolWpJMlBBLSnmNLCW
TRQyq3IRSSZSpqxkdyFeMLunCmY4Egxu2oRGdd1C/VLVVFBWk0rTpmoGg1vQESAi6ndjSRH5WKho
WZXt3d1KSZ1SjUjBUJQupaTIlqFrZkTWy92gWnWq+0QyEkt0GXK629Srhqx0c4I2Dcd648lwMDg+
Ph7Ej8iVsMmWoqGdaFLRFEOVRcwk5lUDKhJtf6m6PNGJCoZeDu/AAlL4T9otRS2gEJP0FIqir30N
/aqqnxCB2xBlvapZIcIexpw9yCcZilU1NKYOqaYX/9nmJqroJtq6002UiPoYIzoNuhOJInGFg6Im
YSNtkzqx1PCOMPFOcI9uQOexrUeSLCumyTpNp925oOFP6McVE403dBj0s6IK7S/jXhYctxWgBEMH
xiNoqICg6zi9UTVd3bVzUcG2m8xgFElanirk7cy4W/EdOqJE0Li/J8ahTx60MG8BTF901GyHHtRQ
NRSiLRgNo65diLOZK5WLinzcp5QOsDA0BB4oaORAPx4ZYwqMqjySJiU8NNFxxdCUEjqhGKaqa9sR
6/6YdLSqoUh3GQYn/MeDzzUs7QHwJJLzpKQLBgjkJrduRV06wizwiciVCiCJiCBMP5VQeGcqke7t
iW6LxZFiGJq+MxrUK4oGBQkHQT20sytGUfE4SIFW6YIP1iAKLdZlnCT/u7pQDMGcTT5RdFCpwBKD
YtHtiR5KS7oiZwxtaz9rSNG9MCfmYDhjkv7GxBoa81nm/wn3+h/vpubc3TUGr//pxut/IpZIOOt/
CkyKxpLpVHpp/b8faZNa0PJKAabw/aMi7rzBTZBVNaWGQduCmxQtrxaCHmLZUCTLS01QqDflS0/6
+wkvg41D8SjjABZNLlXzCnoKRmA3fPD8HinuchWQ4eJFmVZe1ax6XD1ZSZ3gcQbEHl5cVVOBFOOC
0DssVUZVEF+xDNGCWU2Rq5YiUtVCUIA0o9NFIUU9uVhn0G8t9iQXedzDnLgz5qSHOXVnzGkPc8+d
MfeGg18FBhNiOFiUQ5oRRjgPjS1VS9Z2IosuQMxz2GvYV+AhYjYYSyyQUhABIXQqeCoYPKGreWTB
0hSy5Zd0iBONI6ljmELW8UolFyEu3IKnQU0qKxCNbCRT4kZMYRyJHgMM32ZO1+5E0ak4nYaqJZxL
OU8JAI1dAOVxm67AJRtrC7H/E3Mq0M2sQmgjXSA2l/J03t+cP6pt7CSqdtqosK16rKHqZJx1opDj
/zAzn6/a/d+jBhHhr0eM0yN+Wy7c5jgu+eBcGPeovoU4KJ0UrS1hW8lEoRAFYxw8RcvwacjQyzHE
GhJjw+ukpwrSYgx10m2fJxr63J4yWTvVzLJ9Fnd8tsjobdAlbMn+jk24HAvDEk96ZQgU6ai0ByjR
nEagmOpBL21L6TbShPf850HEf3GcceK/uB3/paNL8d/9SJ89/sMbGi8xxqB44+DPJ/ZDsTuJ/HCB
NV1RTC9aMk3F4KI/vO/lI0KfwLEgaxZXyaRR8SIqVhEWyzynimI9V+YITdjUS7zKVl4yJutwE7pe
TwjeWQpr/ZiXwto7DWsbhIbp/z3RbeOoEk8jDS2IpaNJqlpsIm2rsYgdDeNfehxzyxjSOJJcPBRj
LC59Nx6d6oltJCq6Q/FbqlkfjflrmLyLwVj9+c/dX2Og0/X0pBqt/7EeCGHZ+p9O96Tx+r/0/c99
Sr89OLynKRBw8k3CLgHnRloyJJ9hBY/XeDJCr9AKf78grBeWQ77FRZcRMh54kYpmsJXSNcNnmV0h
rTjjgRsomsGAC7Z4LMh44Eu0p7/k9Hjk8GFdX6H4V4LjHlikelSavHxNlO885TtP6Rms6W8DZt8y
+tlA8RuYXRQiTy3UF5BG3rfy+Hllm51f2ZbxwAFKN8Dx/QbwLRduP3VQ2A2RQzrZXcp3ke+5uqZ6
013pZMTUI3EiG9Nh3+3df8gxc7lLb9yOWNUVgm17QPAm5h4sq4XSL6bnLHweaaAv8sE/0QD/RgM5
iQb0Bxrg/7CBnNca4AXwJwRZ8tat2IdpQRQny7om4knGEkVBfPqEOKpMQhymGP0lHLiagjg0tk/M
KwZFj+3rh3BAGZMmSopd5lsC9ZTtKuBpUpZFE+diOCfbeHslAQ3IWiGWdBliPl0T6BoGBZiWqoYX
EGHv8FBfvxiPxCMpbIrdduyvDQPw70Wh1n+q69Q2XPrnNH9+5TiBy4Va2+N0keJXCN4+8p4Lv8yF
v+rCr3Dhr7nwrS587vQHrbnZlr9agYTc1y9aLXMyQX6v9bK3eRZSbwPJwuY/g7+rnsjAE84XcdGN
6wuQNn8H57GKN66S/B/jPDblxkWS/wOcx934xpskfxjyhbNMfuznQzM//Epu5p9yp38yPzI2dOXi
m60ZIXflUoaAK90A5r4FfP9eWPUEDOIL/wEGHcp1zQPInb7Znpt5/8T6C8QiMGP1sXdwwcJ1IH6J
yD92GWtdiLD8X8wT/hf/lQi49GkzCMjNzOcuze3OBd7N/fBT61FH2kNM2qonQI5d/ws7byxH0Iyr
DwHjnAaKHXu35ceACnxIanrnXBArtluotvzsm8DnCPsFZli4euzG88CDn6EFojOnPs7NVOdzM4fm
cjP7rg/PDF4bntl3dXbw49y54dnBq7nZU9dys/uu52aBYBYIodUWqh37Zi4NzdzMzVwh0ude+XRh
AZqu4/uXmdzclcGb3wPPPUf/DV25hH2fvRAH+u/ixnhbGAFnwAN6B09Hc88tEBkoNzN4dW4vCJzt
yGEFZt595wcgyK5o4RMgmh28ycRmv4vRWVJIHt8m1gIPnvzmHqvJvDb34SdU5jVc/g+OzDcAv5ia
GazmWabm5U8dkdfnzjOR171qPgv4C/O7BZS7AgNJQBdu0mcYhBdAIHk+L6ILrfYz7rxYMV+zcE9+
mwiDOtZg8btrOszNbWA6zOHyXzo6/OjjhYWzdoPMFYDhgt0Zz2a/lH0mO7OQPZQdG351c7oJQWd8
tQvDg0MzHw3N/M1w+H0yNi990jz3JRCS+/rPLRT7O9Z/h2d+Ojzz0QBIWFjz97nTlwO5bT+r/hQP
3CPHskezx7JfyYqXz9b6+4eX6VinQzsAswzZGAk+W4+g4HfMHRR8TzqDQmB9844MnVt+8l8LC2cA
DoDKRwFuB7+8BfA1gD8CuAkPYYBJgGvA4d8GeBTgGjoPBJ4fFQJTHYH1K1e0ng2s6MB4HMtcB7lb
XPORP70gPEnpR4B+BBO0d+xpX/v0qodOtr4g7F63Y0viyY0CpcGxwG+Bns+SZm7veLmp/+HlTQdB
kl2OX+b6Uyj/RsBV3nwmgAlwOfbsr0Gbdrj5f52wE9nfhs9aKFdweV97x+829bWv/Z3mwXb06rK+
9tCZllx79OXlufbe0yv2tWeM9t5sezTbHuprR0AH9H3trcTOD+CTATnudYEltDxjPzDI/NIAqlze
5PIvUriSwveW2XIfpvm3Wu3852mexYHraZ6tLesoPEvLN3DlbM3KNNnyWGw60mznWawzRctZWPp9
Ch+icC2Fjwre1Ezh63TdY74bp5D1H7ZGsjC9SO1l+BGaZ3qz+tq4PDSPjmGU0i/QPPPrPM2vo+X3
KznxNpeW033KYxR+kcI0hXza29+/HYUgmg2jdCQRua0tZjO2vqleXjO0xgZffLPTH7z4ZU4/8OJb
nP7ixS/39XMztGrUF9/qtLMX3+b0By8+6IwLL/4hYd4Xv1LI+Pi1GUbViC++3RlnXvwq4aIvvsPZ
53jxq4URX/wjzrj14j/njFcvfo1wzhf/qG//ahYec+JZL/5xZzx68WuF6774zwvzvvh1dTg8zpYJ
v1jg8StJWb3+eP5qAv+/wPl/PcVf5PARiufn2QEiv6YnG+8HyXO9P5+nchAn52VCX98uf9TArj+h
cvZQOc9SfCM//CUpWy28EPTW+7eCv3+EBnL+mfyt72//SeTUt+8q4pBH6vyAKJ63NxHAcur71b8F
8D6zvp88FfDfT44Q/MPCm3S8sPn/I4pn447FFOMB/32s3gB/mMipH6enqfzfp+3yDdohzjTQ840G
8q8AfrVrvLP18scN6OcDuFXq/fNJg3ofAYesblpbN76+QPFzHH5rk21XhuqjUPyOJn/5X27C+tSP
3/UBG3+TwytNtv48fYnW203rZfvnFMH7zMOyYZlWtVCIyLBRf7p/VBweOjgmikLtoEC0yqKMDwRM
oMjr4mRJn5BKYt7SDVOUqlOCrJcrJcVS8pH0tmTSn0gsqJoqSoYhTYuKZhnTQsGQyoqYr5bL08Di
yolAaXlI2bfF4uHhWIo7IlfLLIGUPaPZfYPi4P4BfARCrGHPsBKLgzlKkBsYFcS9wwf6ssPigT17
Dg6OiWPZvuFBTOipPO9FkCMMQRz48v7svqF+evCRybiPM+hhh2xWicW3dS5zOInP0k/UH5Rwohc9
vzkgkm/xxKqp5Bc5zoHGkSyJWkJdyFsADI7f8qYuFiUtT1gd07BP6g58eDETpsk8puBKBXL2I0TM
6bIlTQC0DBsW2RO4UzEqQkTTLSWS7RvqsqRJIVKUzKIQyU9rwGhDyxAik1o1Qt8a9mREKDOUkoQJ
6VOlZGHZoDJ+jEzq8GApU/CXNFHE0Il6EaVIu2Exb9RyNqvdA2wO9vycbBB9pLIqC1isXZMtDKwX
8Hv9ZejCPuP9ThNeZ/HU6Oxpmug4Zue+HD1/PrpJsGN0xl87J7bziKNfxuVjgr3nYPwZyp+hiF6O
j9+39Aj2HoTxs/h0iiKuUXwL1Z3fP+wW7D0K42dx7AjduLB9Dku8/XsFe4/B+Fm8u44qyOZkpi93
3C6MCfaeheVZXBylDKiB/izJVLajP+UfofzMTt5/DF+mZX00z+LsImUYd/E/7sN/Uqh9N4ETWwfe
o/x8hMi3v8Hxs7h9nhKOcPQdHDzF8bP4PkM3sry/+PzLHD+LR0Yo/0Szl77DmxXOcPwsDnmLVtTG
0fP2vyZ4xx+LMy5S/uFb8P8ex1/7vsXOD3D0PP/rHD/bp4xQ/iTX4Xn/fQc+7UJtn1/7Xsqfns/j
I89VLn4Wn569Tf4fUP0ZP4ufz90m/18Ldtsx/tr3YxRBHcPORRg/6wcvcvWz/db5lYvXz+A1jp/F
7a9T/l7Bm3j+f+T4Wdx5faVXT56fpX+hOMbP4r75Bvrz898HFMcfRDD+1Q34GVztqtud2h6z4S9v
Ub9n7XKlVnpQdpYOzF+BT7fgf37kV/+5z9nwNznhfP1L6cEmz/sf96iOxd//sN+XsN//SEXTiRiK
xhLxWEJAqXukjyf9P3//g3v/557Ucfvtn+xJJxK4/RPp5FL734/Evf99T+q4o/Ynv/+H9o8vtf/9
SNz4v2f3Pyz6+894jBv/qVh06f3/+5Lu6P6H+tsg+sgPpmWpJFdLkoV/sE++WxcnpiEzjn9S3egn
8SivkrxmlabJHQEgzSpKFuFhv4CvKEZBN8qMBYoKZjf+oj8iL37Nw7j7bobtDVS4m5c/pKMJevlD
28kiIFGIu5pBDaNd+Jf5Xw22tZnq84poIb1QMBUL7SRXLnwRhUayewfFg0OHB1EXioV31AhNUEk3
RJt+R3CLU+ByNogpq1p9rZ2YHBLSjIplmGgLCtnMYVd1jMauwV21Vi2LFWmSyB8YekYcPXBo/4B4
aCTkrnorZewMEjFtjmSQ5Lz1HIEUBAJ8jUVVw9d7lKZr6pL36UVVE/FPLfCJaEjtdJsXDtuuazOI
x7oG92QPDY9hRdsmgOU4fjpl/wyetD9uGNpTtvv3ps/e+uUyaXcifNNwfFsyzZq+zWnSkG+bhknj
udpLtMAXpn0ZBP4RQCdyMzCv2q3TVte2nHvv0Ltev+JfhFTNW7gWRtz/8LoICU3dqxsW2Ls+tSsW
aqTbIALpSXvvXjjhvksilvS5S8JJrusX6Bv79iUMsG7Ft0c9lzDwBtv319QMRiHvdTV378KMz2J/
Mrotvcj9Ew0cQLgaOOBBL2hLaSktpaW0lG4r/TfMEJPvAFAAAA==
--001a11469e6eac046a055914293f--

