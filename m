From: Boyd Waters <waters.boyd@gmail.com>
Subject: Another hardlink bug case (CUDA dev kit)
Date: Fri, 19 Mar 2010 04:18:25 -0400
Message-ID: <2b0225fb1003190118y1a666adav979f20249c312b67@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I joined the list after this thread:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/4589

but I just found it via google, as I've hit this same bug with a
"real" use-case: the NVIDIA CUDA developer kit.

Upon final installation of this package, I hit the ([Error 31] Too
many Links) error.

It seems that the man pages are all multiply-hard-linked. I'm not sure
that I'm reading this right, but here is "ls -l /opt/cuda/man/man3":

total 3128
-rw-r--r--   1 root root 2675 Mar 19 04:06 CUCTX.3.bz2
-rw-r--r--   1 root root 2202 Mar 19 04:06 CUD3D10.3.bz2
-rw-r--r--   1 root root 3516 Mar 19 04:07 CUD3D10_DEPRECATED.3.bz2
-rw-r--r--   1 root root 2153 Mar 19 04:07 CUD3D11.3.bz2
-rw-r--r--   1 root root 2286 Mar 19 04:07 CUD3D9.3.bz2
-rw-r--r--   1 root root 3944 Mar 19 04:07 CUD3D9_DEPRECATED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA64_MEMCPY3D.3.bz2
-rw-r--r--   1 root root  853 Mar 19 04:07 CUDART.3.bz2
-rw-r--r--   1 root root 1992 Mar 19 04:07 CUDART_D3D10.3.bz2
-rw-r--r--   1 root root 3351 Mar 19 04:07 CUDART_D3D10_DEPRECATED.3.bz2
-rw-r--r--   1 root root 1940 Mar 19 04:07 CUDART_D3D11.3.bz2
-rw-r--r--   1 root root 2046 Mar 19 04:07 CUDART_D3D9.3.bz2
-rw-r--r--   1 root root 3671 Mar 19 04:07 CUDART_D3D9_DEPRECATED.3.bz2
-rw-r--r--   1 root root 3209 Mar 19 04:07 CUDART_DEVICE.3.bz2
-rw-r--r--   1 root root 1044 Mar 19 04:07 CUDART_ERROR.3.bz2
-rw-r--r--   1 root root 1673 Mar 19 04:07 CUDART_EVENT.3.bz2
-rw-r--r--   1 root root 1798 Mar 19 04:07 CUDART_EXECUTION.3.bz2
-rw-r--r--   1 root root 3255 Mar 19 04:07 CUDART_HIGHLEVEL.3.bz2
-rw-r--r--   1 root root 2127 Mar 19 04:07 CUDART_INTEROP.3.bz2
-rw-r--r--   1 root root 7926 Mar 19 04:07 CUDART_MEMORY.3.bz2
-rw-r--r--   1 root root 2237 Mar 19 04:07 CUDART_OPENGL.3.bz2
-rw-r--r--   1 root root 1977 Mar 19 04:07 CUDART_OPENGL_DEPRECATED.3.bz2
-rw-r--r--   1 root root 1008 Mar 19 04:07 CUDART_STREAM.3.bz2
-rw-r--r--   1 root root 2218 Mar 19 04:07 CUDART_TEXTURE.3.bz2
-rw-r--r--   1 root root  811 Mar 19 04:07 CUDART_THREAD.3.bz2
-rw-r--r--   1 root root 2433 Mar 19 04:07 CUDART_TYPES.3.bz2
-rw-r--r--   1 root root  869 Mar 19 04:07 CUDART_VERSION.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ARRAY3D_2DARRAY.3.bz2
-rw-r--r--   1 root root  432 Mar 19 04:07 CUDA_ARRAY3D_DESCRIPTOR.3.bz2
-rw-r--r--   1 root root  401 Mar 19 04:07 CUDA_ARRAY_DESCRIPTOR.3.bz2
-rw-r--r--   1 root root  493 Mar 19 04:07 CUDA_DRIVER.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_ALREADY_ACQUIRED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_ALREADY_MAPPED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_ARRAY_IS_MAPPED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07
CUDA_ERROR_CONTEXT_ALREADY_CURRENT.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_DEINITIALIZED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_FILE_NOT_FOUND.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_INVALID_CONTEXT.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_INVALID_DEVICE.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_INVALID_HANDLE.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_INVALID_IMAGE.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_INVALID_SOURCE.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_INVALID_VALUE.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_LAUNCH_FAILED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07
CUDA_ERROR_LAUNCH_INCOMPATIBLE_TEXTURING.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07
CUDA_ERROR_LAUNCH_OUT_OF_RESOURCES.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_LAUNCH_TIMEOUT.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_MAP_FAILED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NOT_FOUND.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NOT_INITIALIZED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NOT_MAPPED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NOT_MAPPED_AS_ARRAY.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07
CUDA_ERROR_NOT_MAPPED_AS_POINTER.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NOT_READY.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NO_BINARY_FOR_GPU.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_NO_DEVICE.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_OUT_OF_MEMORY.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_POINTER_IS_64BIT.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_SIZE_IS_64BIT.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_UNKNOWN.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_ERROR_UNMAP_FAILED.3.bz2
-rw-r--r-- 169 root root   69 Mar 19 04:07 CUDA_MEMCPY2D.3.bz2
-rw-r--r--   1 root root  617 Mar 19 04:07 CUDA_MEMCPY2D_st.3.bz2
.
,
,


and so on.


I suppose they did this to "de-duplicate" the man pages.

I worked around my installation bug by mounting an ext4 filesystem at
/opt/cuda/man so that the installation could complete.

# uname -a
Linux fun2base 2.6.33-gentoo #1 SMP PREEMPT Wed Mar 17 03:04:23 EDT
2010 x86_64 Intel(R) Core(TM) i7 CPU 860 @ 2.80GHz GenuineIntel
GNU/Linux

Btrfs Btrfs v0.19
